defmodule Stat.Interactions.Presence do
  use Ecto.Schema
  import Ecto.Changeset

  schema "interaction_presences" do
    belongs_to :user, Stat.Accounts.User
    belongs_to :circle, Stat.Events.Circle

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(presence, attrs) do
    presence
    |> cast(attrs, [:presence, :created_at])
    |> cast_assoc(:user)
    |> validate_required([:presence, :created_at, :user_id, :circle_id])
  end
end
