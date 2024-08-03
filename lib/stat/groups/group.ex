defmodule Stat.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :active, :boolean, default: true

    many_to_many :users, Stat.Accounts.User, join_through: Stat.Groups.GroupUser

    timestamps()
  end

  def changeset(group, attrs) do
    group
    |> cast(attrs, [:active])
    |> cast_assoc(:users, required: true)
    |> validate_required([:active])
  end
end
