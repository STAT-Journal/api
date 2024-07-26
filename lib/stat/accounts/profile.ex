defmodule Stat.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :username, :string
    field :avatar, :integer

    belongs_to :user, Stat.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:username, :avatar])
    |> cast_assoc(:user)
    |> assoc_constraint(:user)
    |> validate_required([:username], message: "Username is required")
    |> validate_required([:avatar], message: "Avatar is required")
  end

end
