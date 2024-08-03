defmodule Stat.Mosaic.Participation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mosaic_participations" do
    belongs_to :mosaic, Stat.Mosaic
    belongs_to :user, Stat.Accounts.User

    timestamps()
  end

  def changeset(participation, attrs) do
    participation
    |> cast(attrs, [:mosaic_id, :user_id])
    |> cast_assoc(:mosaic)
    |> cast_assoc(:user)
    |> validate_required([:mosaic_id, :user_id])
  end
end
