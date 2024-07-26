defmodule Stat.Consumables.Postcard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "postcards" do
    field :recipient_valence, :integer

    belongs_to :msg, Stat.Posts.Text
    belongs_to :sticker, Stat.Consumables.StickerType

    belongs_to :author, Stat.Accounts.User
    belongs_to :recipient, Stat.Accounts.User
    belongs_to :postcard_exchange, Stat.Consumables.PostcardExchange

    timestamps()
  end

  @spec changeset(
          {map(), map()}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def changeset(postcard, attrs) do
    postcard
    |> cast(attrs, [:msg_id, :sticker_id, :author_id, :recipient_id, :postcard_exchange_id])
    |> assoc_constraint(:msg)
    |> assoc_constraint(:sticker)
    |> assoc_constraint(:author)
    |> assoc_constraint(:recipient)
    |> assoc_constraint(:postcard_exchange)
    |> validate_required([:author_valence, :recipient_valence, :msg_id, :sticker_id, :author_id, :recipient_id, :postcard_exchange_id])
  end

end
