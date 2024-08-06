defmodule StatWeb.Schemas.Mosaics do
  use Absinthe.Schema.Notation

  object :mosaic_instance do
    field :id, :integer
    field :created_at, :string
  end

  object :participation_result do
    field :interactions, non_null(:integer)
  end

  object :mosaic_result do
    field :id, :integer
    field :seed, :integer
    field :participation_results, non_null(list_of(:participation_result))
  end
end
