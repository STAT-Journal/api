defmodule Stat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :last_confirmed_at, :utc_datetime

    has_one :balance, Stat.Consumables.Balance
    has_many :weeklycheckins, Stat.Posts.WeeklyCheckIn
    has_many :moments, Stat.Posts.Moment
    has_many :texts, Stat.Posts.Text
    has_many :transactions, Stat.Consumables.Transaction

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
end
