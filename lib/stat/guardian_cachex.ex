defmodule Stat.GuardianCachex do
  @behaviour Guardian.DB.Adapter

  @cache_name :guardian

  # From https://github.com/alexfilatov/guardian_redis
  defp key(%{changes: %{jti: jti, aud: aud}}), do: combine_key(jti, aud)
  defp key(%{"jti" => jti, "aud" => aud}), do: combine_key(jti, aud)
  defp key(query), do: combine_key(jti_elem(query), aud_elem(query))
  defp sub_elem(%{changes: %{sub: sub}}), do: sub
  defp sub_elem(%{"sub" => sub}), do: sub
  defp sub_elem(query), do: query_param(query, :sub)
  defp jti_elem(query), do: query_param(query, :jti)
  defp aud_elem(query), do: query_param(query, :aud)
  defp combine_key(jti, aud), do: "#{jti}:#{aud}"
  defp set_name(sub), do: "set:#{sub}"
  defp query_param(query, param) do
    query
    |> Map.get(param)
  end


  @impl true
  def purge_expired_tokens(_exp, _opts) do
    Cachex.purge(@cache_name)
    |> case do
      {:ok, number} -> {number, []}
      {:error, _} -> {0, []}
    end
  end

  @impl true
  def insert(schema_or_changeset, _opts) do
    exp = schema_or_changeset.changes.exp
    ttl = exp - System.system_time(:second)
    ttl_in_ms = ttl * 1000

    now_utc = System.os_time(:second)

    insertion_record = schema_or_changeset.changes
    |> Map.put(:inserted_at, now_utc)
    |> Map.put(:updated_at, now_utc)

    insertion_key = key(insertion_record)
    set_key = set_name(sub_elem(insertion_record))
    Cachex.transaction(@cache_name, [insertion_key, set_key], fn worker ->
      insertion = Cachex.put(worker, insertion_key, insertion_record, ttl: ttl_in_ms)
      set = Cachex.get_and_update(worker, set_key, fn
        (nil) -> {:commit, insertion_key}
        (val) -> {:commit, [insertion_key | val]}
      end, ttl: -1) # never expire
      [insertion, set]
    end)
    |> case do
      {:ok, _} -> {:ok, schema_or_changeset}
      {:error, _} ->
        {:error , schema_or_changeset}
    end
  end

  @impl true
  def delete(schema_or_changeset, _opts) do
    key = key(schema_or_changeset)
    Cachex.del(@cache_name, key)
    |> case do
      {:ok, _} -> {:ok, schema_or_changeset}
      {:error, _} ->
        {:error , schema_or_changeset
        |> Ecto.Changeset.add_error(:error, "Failed to delete record")}
    end
  end

  @impl true
  def delete_by_sub(sub, _opts) do
    set_key = set_name(sub)
    records = case Cachex.get(@cache_name, set_key) do
      {:ok, nil} -> []
      {:ok, records} -> records
      {:error, _} -> []
    end


    Cachex.transaction(@cache_name, [set_key], fn worker ->
      records
      |> Enum.map(&key/1) # get keys
      |> Enum.map(&Cachex.del(worker, &1)) # delete records
      end)
    |> case do
      {:ok, _} -> {records |> Enum.count(), records}
      {:error, _} -> {0, nil}
    end
  end

  @impl true
  def one(claims, _opts) do
    key = key(claims)
    Cachex.get(@cache_name, key)
    |> case do
      {:ok, record} -> record
      {:error, _} -> nil
    end
  end
end
