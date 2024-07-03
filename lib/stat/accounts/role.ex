defmodule Stat.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, Ecto.Enum, values: [:admin, :user]

    belongs_to :user, Stat.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:name, :user_id])
  end
end
