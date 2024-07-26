defmodule StatWeb.Schema do
  use Absinthe.Schema

  import_types StatWeb.Schemas.Auths
  import_types StatWeb.Schemas.Users
  import_types StatWeb.Schemas.Posts
  import_types StatWeb.Schemas.Consumables

  alias StatWeb.Resolvers.Users
  alias StatWeb.Resolvers.Posts
  alias StatWeb.Resolvers.Auths
  alias StatWeb.Resolvers.Consumables

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [StatWeb.Middlewares.HandleChangesetErrors]
  end

  def middleware(middleware, _field, _object) do
    middleware ++ [StatWeb.Middlewares.HandleBadAuth]
  end

  query do
    field :verify_renewal_token, :user do
      arg :renewal_token, non_null(:string)
      resolve &Auths.check_renewal_token/3
    end

    field :verify_session_token, :user do
      arg :session_token, non_null(:string)
      resolve &Auths.check_session_token/3
    end

    # User-related queries
    field :me, :user do
      resolve &Users.get_user/3
    end

    # Post-related queries
    field :list_text_posts, list_of(:text_post) do
      resolve &Posts.list_text_posts/3
    end

    field :unsafe_check_if_user_can_check_in, :boolean do
      resolve &Posts.unsafe_check_if_user_can_check_in/3
    end

    field :list_moments, list_of(:moment) do
      resolve &Posts.list_moments/3
    end

    # Consumable-related queries
    field :list_transactions, list_of(:transaction) do
      resolve &Consumables.list_transactions/3
    end
    100
  end

  mutation do
    field :dev_get_session_token, :string do
      resolve fn _, _, _ ->
        user = Stat.Accounts.User |> Ecto.Query.first |> Stat.Repo.one
        Stat.Guardian.encode_and_sign(user, %{type: "session"}) |>
        case do
          {:ok, token, _} -> {:ok, token}
          {:error, msg} -> {:error, msg}
        end
      end
    end

    # Auth-related mutations
    field :register, :string do
      arg :email, non_null(:string)
      resolve &Auths.register/3
    end

    field :renew_renewal_token, :string do
      arg :renewal_token, non_null(:string)
      resolve &Auths.refresh_renewal_token/3
    end

    field :get_session_token, :string do
      arg :renewal_token, non_null(:string)
      resolve &Auths.get_session_token/3
    end

    # User-related mutations
    field :create_profile, :profile do
      arg :username, non_null(:string)
      arg :avatar, :integer
      resolve &Users.create_profile/3
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

    # Consumable-related mutations
    field :buy_sticker, :transaction do
      arg :sticker_type, non_null(:id)
      resolve &Consumables.buy_sticker/3
    end
  end
end
