defmodule StatWeb.Schema do
  use Absinthe.Schema

  import_types StatWeb.Schemas.Auths
  import_types StatWeb.Schemas.Users
  import_types StatWeb.Schemas.Posts
  import_types StatWeb.Schemas.Consumables
  import_types StatWeb.Schemas.Mosaics
  import_types StatWeb.Schemas.Broadcasts
  import_types StatWeb.Schemas.Presences

  alias StatWeb.Resolvers.Users
  alias StatWeb.Resolvers.Posts
  alias StatWeb.Resolvers.Auths
  alias StatWeb.Resolvers.Consumables
  alias StatWeb.Resolvers.Mosaics
  alias StatWeb.Resolvers.Presences

  def middleware(middleware, _field, %{identifier: :mutation}) do
    [StatWeb.Middlewares.HandleAuth] ++ middleware ++ [StatWeb.Middlewares.HandleChangesetErrors]
  end

  def middleware(middleware, _field, _object) do
    [StatWeb.Middlewares.HandleAuth] ++ middleware
  end

  query do
    # User-related queries
    field :me, :private_user do
      resolve &Users.get_user/3
    end

    # Post-related queries
    field :list_text_posts, non_null(list_of(non_null(:text_post))) do
      resolve &Posts.list_text_posts/3
    end

    field :unsafe_check_if_user_can_check_in, :boolean do
      resolve &Posts.unsafe_check_if_user_can_check_in/3
    end

    field :list_moments, non_null(list_of(:moment)) do
      resolve &Posts.list_moments/3
    end

    # Consumable-related queries
    field :list_transactions, non_null(list_of(:transaction)) do
      resolve &Consumables.list_transactions/3
    end

  end

  mutation do
    # Auth-related mutations
    field :register, :string do
      arg :email, non_null(:string)
      resolve &Auths.register/3
    end

    field :renew_refresh_token, :auth_blob do
      arg :refresh_token, non_null(:string)
      resolve &Auths.renew_refresh_token/3
    end

    field :exchange_refresh_for_access_token, :auth_blob do
      arg :refresh_token, non_null(:string)
      resolve &Auths.exchange_refresh_for_access_token/3
    end

    # User-related mutations
    field :add_username, :public_user do
      arg :username, non_null(:string)
      resolve &Users.add_username/3
    end

    field :add_avatar, :public_user do
      arg :avatar, non_null(:avatar_input)
      resolve &Users.add_avatar/3
    end

    field :create_follow, :follow do
      arg :followed_id, non_null(:id)
      resolve &Users.create_follow/3
    end

    # Post-related mutations
    field :create_text_post, :text_post do
      arg :body, non_null(:string)
      resolve &Posts.create_text_post/3
    end

    field :create_moment, :moment do
      arg :type, non_null(:moment_type)
      resolve &Posts.create_moment/3
    end

    field :create_weekly_checkin, :weekly_check_in do
      arg :valence, non_null(:string)
      resolve &Posts.create_weekly_checkin/3
    end

    # Subscription utilties
    field :create_prescence, non_null(:string) do
      arg :presence, non_null(:presence)
      resolve &Presences.presence/3
    end

    # Mosiac-related mutations
    field :participate_in_mosaic, :mosaic do
      arg :mosaic_participation, non_null(:mosaic_participation)
      resolve &Mosaic.participate_in_mosaic/3
    end
  end

  subscription do
    field :mosaic_circle, :mosaic do
      config fn _args, _info ->
        {:ok, topic: "mosaic_circle"}
      end
    end

    field :broadcasts, :broadcast do
      config fn _args, _info ->
        {:ok, topic: "broadcasts"}
      end
    end
  end
end
