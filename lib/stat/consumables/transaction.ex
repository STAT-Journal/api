defmodule Stat.Consumables.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :change, :integer # This is the amount of stickers that were added (+ given) or removed (- used)

    belongs_to :user, Stat.Accounts.User
    belongs_to :sticker_type, Stat.Consumables.StickerType

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:change])
    |> validate_required([:change])
  end
end
