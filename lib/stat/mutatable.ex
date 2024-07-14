defprotocol Stat.Mutatable do
  alias Stat.Repo

  def changeset(type, args)

  def create(type, args)

  def create_for_user(type, args, user)
end

defimpl Stat.Mutatable, for: [Ecto.Schema] do
  def changeset(type, args) do
    type
    |> Ecto.Changeset.cast(args, Map.keys(args))
  end

  def create(type, args) do
    type
    |> changeset(args)
    |> Repo.insert()
  end

  def create_for_user(type, args, user) do
    type
    |> changeset(args)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end
end
