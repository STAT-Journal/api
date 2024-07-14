defmodule StatWeb.Schemas.Users do
  use Absinthe.Schema.Notation

  object :persona do
    field :id, :id
    field :username, :string
  end

  object :user do
    field :id, :id
    field :email, :string
    field :main_persona, :persona
    field :alt_personas, list_of(:persona)
  end
end
