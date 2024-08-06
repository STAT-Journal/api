defmodule StatWeb.Schemas.Users do
  use Absinthe.Schema.Notation

  object :avatar do
    field :style, :string
    field :options, :string # JSON
  end

  input_object :avatar_input do
    field :style, non_null(:string)
    field :options, non_null(:string) # JSON
  end

  object :public_user do
    field :username, :string
    field :avatar, :avatar
  end

  object :private_user do
    field :email, non_null(:string)
    field :public, non_null(:public_user)
  end

  object :follow_token do
    field :token, non_null(:string)
  end

  object :follow do
    field :follower, non_null(:public_user)
    field :followee, non_null(:public_user)
  end
end
