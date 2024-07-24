defmodule StatWeb.Schemas.Users do
  use Absinthe.Schema.Notation

  object :profile do
    field :username, :string
  end

  object :user do
    field :email, :string
    field :main_profile, :profile
    field :alt_profile, list_of(:profile)
  end

  object :follow do
    field :follower, :profile
    field :followee, :profile
  end
end
