defmodule Stat.Consumables.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :currency_change, :integer # Either the cost of a purchase or the amount of currency earned

    belongs_to :user, Stat.Accounts.User
    belongs_to :sticker_type, Stat.Consumables.StickerType
    

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [])
  end
end
