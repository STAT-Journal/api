defmodule Stat.Servers.MosaicInstance do
  use GenServer

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

  def reset_game_id do
    Cachex.put(@cache_name, :id, 0, ttl: -1)
  end

  def get_game_from_manifest(instance_id) do
    Cachex.get(@cache_name, instance_manifest_key())
    |> case do
      {:ok, games} -> {:ok, Map.get(games, instance_id)}
      _ -> {:ok, nil}
    end
  end

  def init(state) do
    {:ok, state}
  end

  def new_game() do
    {:ok, new_game_id} = new_game_id()

    now = DateTime.utc_now()
    ends_at = DateTime.utc_now() |> DateTime.add(@game_ttl / 1000, :second)

    payload = %{
      id: new_game_id,
      created_at: now,
      ends_at: ends_at
    }

    Cachex.get_and_update(@cache_name, instance_manifest_key(), fn
      (old) -> (old || %{}) |> Map.put(payload.id, payload)
    end, ttl: -1)
    |> schedule_check(ends_at, @game_ttl)
  end

  def notify_user_participation(participation, instance_id, user) do
    Absinthe.Subscription.publish(StatWeb.Endpoint, {:mosaic_instance, instance_id}, %{
      user_id: user.id,
      participation_count: participation
    })
  end

  def receive_participation(instance_id, user) do
    case get_game_from_manifest(instance_id) do
      {:ok, nil} -> {:error, "Game not found or ended"}
      {:ok, _game} ->
        user_key = user_instance_key(instance_id, user)
        Cachex.incr(@cache_name, user_key, 1, ttl: @game_ttl * 2)
    end
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

  def complete_game(instance_id) do
    # delete the instance from the cache
    # This prevents users from participating in the game after it has ended
    Cachex.get_and_update(@cache_name, instance_key(instance_id), fn
      (old) ->
        (old || %{}) |> Map.delete(instance_id)
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
        Absinthe.Subscription.publish(StatWeb.Endpoint, {:mosaic_instance_results, instance_id}, %{
          id: result.id,
          seed: result.seed,
          participation_results: data[:participations]
        })
      {:error, _} ->
        Absinthe.Subscription.publish(StatWeb.Endpoint, {:mosaic_instance_results, instance_id}, %{})
        :error
    end
  end

  def handle_info({:complete_game, instance_id}, _state) do
    case complete_game(instance_id) do
      :ok -> {:noreply, _state}
      :error -> {:noreply, _state}
    end
  end

  def schedule_check({:commit, payload}) do
    try do
      Process.send_after(self(), {:complete_game, payload[:id]}, payload[:ends_at] - DateTime.utc_now() |> DateTime.to_unix())
      |> case do
        _ -> :ok
      end
    rescue
      _ -> :error
    end
  end

  def schedule_check({_, _}, ends_at, ttl) do
    :error
  end
end
