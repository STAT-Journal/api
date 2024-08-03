defmodule Stat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :last_confirmed_at, :utc_datetime

    has_one :avatar, Stat.Accounts.Avatar
    field :username, :string

    has_one :balance, Stat.Consumables.Balance
    has_many :transactions, Stat.Consumables.Transaction

    has_many :weeklycheckins, Stat.Posts.WeeklyCheckIn
    has_many :moments, Stat.Posts.Moment
    has_many :texts, Stat.Posts.Text

    many_to_many :groups, Stat.Groups.Group, join_through: Stat.Groups.GroupUser
    timestamps(type: :utc_datetime)
  end

  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> unique_constraint(:email)
  end

  defp validate_email(changeset, _) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end

  def confirm_changeset(user) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    user
    |> change(last_confirmed_at: now)
  end

  def validate_username(changeset) do
    changeset
    |> validate_required([:username])
    |> validate_length(:username, min: 3, max: 20, message: "must be between 3 and 20 characters")
    |> validate_format(:username, ~r/^[a-zA-Z0-9_]+$/, message: "can only contain letters, numbers, and underscores")
  end

  def unsafe_username_changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> unsafe_validate_unique(:username, Stat.Repo, message: "is already taken")
  end

  def username_changeset(user, attrs) do
    # Make sure that the username is not already set
    case user.username do
      nil ->
        user
        |> cast(attrs, [:username])
        |> validate_username()
        |> unique_constraint(:username)
      _ ->
        {:error, "Username already set"}
    end
  end
end
