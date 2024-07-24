defmodule Stat.Accounts.Profile do
  alias Stat.Repo
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
    |> cast_assoc(:user)
    |> validate_required([:username], message: "Username is required")
    |> validate_required(:user_id, message: "User is required")
  end

end
