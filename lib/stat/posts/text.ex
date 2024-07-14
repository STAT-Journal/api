defmodule Stat.Posts.Text do
  use Ecto.Schema
  import Ecto.Changeset

  schema "texts" do
    belongs_to :user, Stat.Accounts.User
    field :deleted_at, :utc_datetime
    field :body, :string

    timestamps()
  end

  @doc false
  def changeset(text, attrs) do
    text
    |> cast(attrs, [:body, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:body, :user_id])
  end
end
