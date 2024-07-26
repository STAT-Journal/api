defmodule Stat.Consumables.PostcardExchange do
  use Ecto.Schema
  import Ecto.Query

  schema "postcard_exchanges" do
    field :author_valence, :integer
    field :recipient_valence, :integer

    has_many :postcards, Stat.Consumables.Postcard
    timestamps()
  end
end
