defmodule StatWeb.Schema do
  use Absinthe.Schema
  import_types StatWeb.Schemas.Auths
  import_types StatWeb.Schemas.Users
  import_types StatWeb.Schemas.Posts

  alias StatWeb.Resolvers.Users
  alias StatWeb.Resolvers.Posts
  alias StatWeb.Resolvers.Auths

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [StatWeb.Middlewares.HandleChangesetErrors]
  end

  def middleware(middleware, _field, _object), do: middleware

  query do
    field :list_text_posts, list_of(:text_post) do
      resolve &Posts.list_text_posts/3
    end

    field :login, :auth do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &Auths.login/3
    end

    field :me, :user do
      resolve &Users.get_user/3
    end
  end

  mutation do
    field :register, :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &Auths.register/3
    end

    field :profile, :profile do
      arg :username, non_null(:string)
      resolve &Users.create_profile/3
    end
  end
end
