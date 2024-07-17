defmodule Stat.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :username, :string

    belongs_to :user, Stat.Accounts.User
    belongs_to :city, Stat.Locations.City

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:username, :city_id, :user_id])
    |> validate_required([:username])
  end
end
