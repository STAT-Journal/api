defmodule Stat.Posts.Moment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "moments" do
    field :type, Ecto.Enum, values: [:good, :bad], null: false

    belongs_to :user, Stat.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(moment, attrs) do
    moment
    |> cast(attrs, [:type, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:type, :user_id])
  end
end
