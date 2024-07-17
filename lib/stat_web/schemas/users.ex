defmodule StatWeb.Schemas.Users do
  use Absinthe.Schema.Notation

  object :profile do
    field :id, :id
    field :username, :string
  end

  object :user do
    field :id, :id
    field :email, :string
    field :main_profile, :profile
    field :alt_profile, list_of(:profile)
  end
end
