defmodule StatWeb.Schemas.Broadcasts do
  use Absinthe.Schema.Notation

  object :broadcast do
    field :id, :id
    field :message, :string
  end
end
