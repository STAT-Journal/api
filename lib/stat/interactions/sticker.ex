defmodule Stat.Interactions.Sticker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "interaction_stickers" do
    belongs_to :sticker_type, Stat.Consumables.StickerType
    belongs_to :user, Stat.Accounts.User

    belongs_to :moment, Stat.Posts.Moment
    belongs_to :checkin, Stat.Posts.Checkin

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sticker, attrs) do
    sticker
    |> cast(attrs, [])
    |> validate_required([:sticker_type_id, :user_id])
  end
end
