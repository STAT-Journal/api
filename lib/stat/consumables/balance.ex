defmodule Stat.Consumables.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "balances" do
    field :balance, :integer, default: 0
    belongs_to :user, Stat.Accounts.User

    timestamps()
  end

  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:user_id, :balance])
    |> assoc_constraint(:user)
    |> validate_number(:balance, greater_than_or_equal_to: 0, message: "Insufficient balance")
  end
end
