defmodule Stat.Presence do
  alias Stat.Accounts.User
  alias Stat.Presences.Presence

  @cache_name :presence
  @default_ttl 900000 # in ms, 15 minutes

  def add_presence(user, attrs) do
    Cachex.put(@cache_name, user.id, attrs, ttl: @default_ttl)
  end

  def get_current_presences do
    query = Cachex.Query.create(true, {:key, :value})
    Cachex.stream(@cache_name, query)
    |> Enum.to_list()
  end

  def clear_presence(user) do
    Cachex.del(@cache_name, user.id)
  end

  def clear_all do
    Cachex.clear(@cache_name)
  end
end
