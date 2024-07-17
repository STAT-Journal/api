defmodule StatWeb.Schemas.Auths do
  use Absinthe.Schema.Notation

  object :auth do
    field :token, :string
  end
end
