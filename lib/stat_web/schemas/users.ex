defmodule StatWeb.Schemas.Users do
  use Absinthe.Schema.Notation

  object :profile do
    field :username, :string
    field :avatar, :integer
  end

  object :user do
    field :email, :string
    field :profile, :profile
  end

  object :follow do
    field :follower, :profile
    field :followee, :profile
  end
end
