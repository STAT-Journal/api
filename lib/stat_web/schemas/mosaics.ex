defmodule StatWeb.Schemas.Mosaics do
  use Absinthe.Schema.Notation

  object :mosaic do
    field :id, :id
    field :created_at, :integer
    field :ends_at, :integer
    field :size, :integer
  end

  input_object :mosaic_participation do
    field :mosaic_id, :id
  end
end
