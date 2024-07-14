defmodule StatWeb.Schema do
  use Absinthe.Schema
  import_types StatWeb.Schemas.Users
  import_types StatWeb.Schemas.Posts

  alias StatWeb.Resolvers.Posts

  query do
    field :list_text_posts, list_of(:text_post) do
      resolve &Posts.list_text_posts/3
    end
  end

  mutation do
    field :create_user, :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &StatWeb.Resolvers.Users.create_user/3
    end
  end
end
