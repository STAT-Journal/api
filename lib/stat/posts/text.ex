defmodule Stat.Posts.Text do
  use Ecto.Schema
  import Ecto.Changeset

  schema "texts" do
    belongs_to :user, Stat.Accounts.User
    field :deleted_at, :utc_datetime
    field :body, :string

    timestamps()
  end

  def changeset(text, attrs) do
    text
    |> cast(attrs, [:body, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:body, :user_id])
  end

  def update_changeset(text, attrs) do
    text
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end

  def delete_changeset(text) do
    text
    |> put_change(:deleted_at, DateTime.utc_now())
  end

  def undelete_changeset(text) do
    text
    |> put_change(:deleted_at, nil)
  end
end
