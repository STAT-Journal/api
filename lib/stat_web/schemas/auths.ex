defmodule StatWeb.Schemas.Auths do
  use Absinthe.Schema.Notation

  object :claims do
    field :sub, non_null(:string)
    field :exp, non_null(:integer)
    field :iat, non_null(:integer)
  end

  object :auth_blob do
    field :token, non_null(:string)
    field :claims, non_null(:claims)
  end
end
