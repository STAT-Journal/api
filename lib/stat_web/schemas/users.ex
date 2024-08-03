defmodule StatWeb.Schemas.Users do
  use Absinthe.Schema.Notation

  object :avatar do
    field :style, :string
    field :options, :string # JSON
  end

  input_object :avatar_input do
    field :style, :string
    field :options, :string # JSON
  end

  object :public_user do
    field :username, :string
    field :avatar, :avatar
  end

  object :private_user do
    field :email, :string
    field :public, :public_user
  end

  object :follow do
    field :follower, :public_user
    field :followee, :public_user
  end
end
