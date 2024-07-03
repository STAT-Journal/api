defmodule Stat.Events.Circle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "circles" do
    many_to_many :members, Stat.Accounts.User,
      join_through: "circle_members"

    has_many :presences, Stat.Interactions.Presence

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(circle, attrs) do
    circle
    |> cast(attrs, [:name, :description, :created_at])
    |> cast_assoc(:user)
    |> cast_assoc(:members)
    |> validate_required([:name, :description, :created_at])
  end
end
