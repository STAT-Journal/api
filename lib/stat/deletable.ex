defprotocol Stat.Deletable do
  def delete_changeset(changeset)

  def undelete_changeset(changeset)
end

defimpl Stat.Deletable, for: [Ecto.Type, Ecto.Schema] do
  require Ecto.Changeset

  def delete_changeset(changeset) do
    changeset
    |> Ecto.Changeset.put_change(:deleted_at, DateTime.utc_now())
  end

  def undelete_changeset(changeset) do
    changeset
    |> Ecto.Changeset.put_change(:deleted_at, nil)
  end
end
