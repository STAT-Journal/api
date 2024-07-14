defprotocol Stat.Queryable do
  def where_deleted(type)

  def where_not_deleted(type)

  def where_id(type, id)

  def where_user(type, user)

  def prefetch_user(type)
end


defimpl Stat.Queryable, for: [Ecto.Schema, Ecto.Query] do
  require Ecto.Query

  def where_deleted(type) do
    type
    |> Ecto.Query.where([p], not is_nil(p.deleted_at))
  end

  def where_not_deleted(type) do
    type
    |> Ecto.Query.where([p], is_nil(p.deleted_at))
  end

  def where_id(type, id) do
    type
    |> Ecto.Query.where([p], p.id == ^id)
  end

  # Todo: figure out how to determine if user_id exists in schema
  # We want compile-time errors if the user_id field does not exist
  def where_user(type, user) do
    type
    |> Ecto.Query.where([p], p.user_id == ^user.id)
  end

  def prefetch_user(type) do
    type
    |> Ecto.Query.preload(:user)
  end
end