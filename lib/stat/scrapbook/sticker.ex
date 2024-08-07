defmodule Stat.Scrapbook.Sticker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scrapbook_stickers" do
    belongs_to :transaction, Stat.Consumables.Transaction

    timestamps()
  end

end
