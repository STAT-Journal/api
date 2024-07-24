defmodule StatWeb.Schemas.Consumables do
  use Absinthe.Schema.Notation

  object :sticker_type do
    field :name, :string
    field :url, :string
  end

  object :consumable do
    field :name, :string
    field :quantity, :integer
  end

  object :transaction do
    field :sticker_type, :sticker_type
    field :change, :integer
  end
end
