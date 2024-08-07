defmodule Stat.Jobs.CompleteMosaic do
  use Oban.Worker, queue: :mosaic

  @cache_name :mosaic_instance

  def instance_manifest_key do
    "instance_manifest"
  end

  def instance_key(id) do
    "instance#{id}"
  end

  def user_instance_key(instance_id, user) do
    "instance#{instance_id}_user#{user.id}"
  end

  def user_id_from_user_instance_key(key) do
    String.split(key, "_user") |> List.last() |> String.to_integer()
  end

  def user_instance_query(instance_id) do
    Cachex.Query.create(fn key -> String.contains?(key, "instance#{instance_id}_user") end, {:key, :value})
  end

  def new_game_id do
    Cachex.incr(@cache_name, :id, 1, ttl: -1)
  end

  def reset_game_id do
    Cachex.put(@cache_name, :id, 0, ttl: -1)
  end



  def process_results(results, result_id) do
    results
    |> Enum.map(fn {key, value} -> %{
      participation_count: value,
      user_id: user_id_from_user_instance_key(key),
      result_id: result_id
    }
    end)
  end


  def complete_game(instance_id) do
    # delete the instance from the cache
    # This prevents users from participating in the game after it has ended
    Cachex.get_and_update(@cache_name, instance_manifest_key(), fn games ->
      Map.delete(games || %{}, instance_id)
    end)

    seed = Enum.random(1..1000)

    result = %Stat.Mosaic.Result{} |> Stat.Mosaic.Result.changeset(%{seed: seed})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:result, result)
    |> Ecto.Multi.insert_all(:participations, Stat.Mosaic.UserParticipationResult, fn %{result: result} ->
      instance_results = Cachex.stream(@cache_name, user_instance_query(instance_id))

      process_results(instance_results, result.id)
      end)
    |> Stat.Repo.transaction()
    |> case do
      {:ok, data} ->
        Absinthe.Subscription.publish(StatWeb.Endpoint, {:mosaic_instance_results, instance_id},
          id: data[:result].id,
          seed: data[:result].seed,
          participation_results: data[:participations]
      )
      {:error, _} ->
        Absinthe.Subscription.publish(StatWeb.Endpoint, {:mosaic_instance_results, instance_id},
          id: nil,
          seed: nil,
          participation_results: []
      )
        :error
    end
  end


  def perform(%Oban.Job{args: %{"id" => id}}) do
    case complete_game(id) do
      :error -> {:error, "Failed to complete game"}
      _ -> :ok
    end
  end
end
