defmodule StatWeb.Resolvers.Mosaics do
  @cache_name :mosaic_instance
  @game_ttl 300000 # in ms, 5 minutes

  def instance_manifest_key do
    "instance_manifest"
  end


  def user_instance_key(instance_id, user) do
    "instance#{instance_id}_user#{user.id}"
  end

  defp get_game_from_manifest(instance_id) do
    Cachex.get(@cache_name, instance_manifest_key())
    |> case do
      {:ok, games} -> {:ok, Map.get(games, instance_id)}
      _ -> {:ok, nil}
    end
  end

  defp receive_participation(instance_id, user) do
    case get_game_from_manifest(instance_id) do
      {:ok, nil} -> {:error, "Game not found or ended"}
      {:ok, _game} ->
        user_key = user_instance_key(instance_id, user)
        Cachex.incr(@cache_name, user_key, 1, ttl: @game_ttl * 2)
    end
  end

  def participate_in_mosaic(_,
    %{mosaic_participation: %{mosaic_id: mosaic_id}},
    %{context: %{current_user: user}}) do
    receive_participation(mosaic_id, user)
  end

  def mosaic_instances(_, _, _) do
    Cachex.get(@cache_name, instance_manifest_key())
    |> case do
      {:ok, games} -> {:ok, games |> Map.keys()}
      _ -> {:ok, []}
    end
  end
end
