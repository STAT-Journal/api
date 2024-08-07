defmodule Stat.Jobs.Mosaic do
  use Oban.Worker, queue: :mosaic

  import Ecto.Query

  @cache_name :mosaic_instance
  @game_ttl 300000 # in ms, 5 minutes

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


  def new_game do
    IO.inspect("New game")
    instance_id = new_game_id()
    Cachex.get_and_update(@cache_name, instance_manifest_key(), fn games ->
      Map.put(games || %{}, instance_id, %{})
    end)
    |> schedule_check()
    |> case do
      {:ok, changeset} ->
        Absinthe.Subscription.publish(StatWeb.Endpoint, {:mosaic_instance, instance_id}, instance_id)
        {:ok, instance_id}
      _ -> {:error, :failed_to_schedule_check}
    end
  end

  def current_games do
    Cachex.get(@cache_name, instance_manifest_key())
    |> case do
      {:ok, games} -> {:ok, games |> Map.values()}
      _ -> {:ok, []}
    end
  end

  def fetch_results(result_id) do
    Stat.Mosaic.Result
    |> where([r], r.id == ^result_id)
    |> preload(:participations)
    |> Stat.Repo.one()
  end


  def schedule_check({:commit, payload}) do
    IO.inspect("Scheduling check")
    %{id: payload.id, ends_at: payload.ends_at}
    |> Stat.Jobs.CompleteMosaic.new()
    |> Oban.insert(schedule_in: @game_ttl / 1000) # in seconds
  end

  def schedule_check({_, _}) do
    {:error, nil}
  end

  def perform(_) do
    new_game()
  end
end
