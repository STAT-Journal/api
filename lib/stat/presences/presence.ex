defmodule Stat.Presences.Presence do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "presences" do
    field :number_of_interactions, :integer
    field :start_period, :utc_datetime
    field :end_period, :utc_datetime
    belongs_to :user, Stat.Accounts.User
  end

  def changeset(presence, attrs) do
    presence
    |> cast(attrs, [:number_of_interactions, :start_period, :end_period, :user_id])
    |> validate_required([:number_of_interactions, :start_period, :end_period, :user_id])
  end
end
