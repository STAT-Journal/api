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
    field :me, non_null(:private_user) do
      resolve &Users.get_user/3
    end

    field :get_follow_token, :string do
      resolve &Users.get_follow_token/3
    end

    field :get_followers, non_null(list_of(non_null(:public_user))) do
      resolve &Users.get_followers/3
    end

    field :get_following, non_null(list_of(non_null(:public_user))) do
      resolve &Users.get_following/3
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

    field :list_moments_for_graph, non_null(list_of(non_null(:moment_graph_item))) do
      resolve &Posts.list_moments_for_graph/3
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
      arg :follow_token, non_null(:string)
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

    field :participate_in_mosaic, :integer do
      arg :mosaic_id, non_null(:integer)
      resolve &Mosaics.participate_in_mosaic/3
    end

    field :be_present, :string do # SVG of other avatars lol
      arg :avatar_svg, non_null(:string)
      resolve fn args, _info ->
        {:ok, args.avatar_svg}
      end

    end
  end

  subscription do
    field :presence, :string do # SVG of other avatars lol
      config fn _args, _info ->
        {:ok, topic: "presence"}
      end

      trigger :be_present, topic: fn _ -> "presence" end

      resolve fn args, _, _info ->
        {:ok, args}
      end
    end

    # field :mosaic_instance_results, :mosaic_instance_result do
    #   arg :mosaic_instance_id, non_null(:integer)

    #   config fn args, _info ->
    #     {:ok, topic: "mosaic_instance_results_#{args.mosaic_instance_id}"}
    #   end

    #   resolve &Mosaics.mosaic_instance_results/3
    # end

  end
end
