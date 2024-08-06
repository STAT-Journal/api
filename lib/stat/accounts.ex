defmodule Stat.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query
  alias Ecto.Multi
  alias Stat.Repo
  alias Stat.Guardian

  alias Stat.Accounts.{Avatar, User, UserNotifier, Follow}

  @refresh_token_ttl {4, :weeks} # Stored by clients and used to renew access tokens
  @access_token_ttl {3, :hours} # Used to authenticate requests
  @confirmation_token_ttl {30, :minutes} # Used to confirm user email
  @default_follow_token_ttl {2, :days}

  def create_user_confirmation_url({:ok, token, _, user}) do
    {:ok, user, StatWeb.Endpoint.url() <> "/verify?token=#{token}"}
  end

  def create_user_confirmation_url({:error, error, _user}) do
    {:error, error}
  end

  def encode_and_sign_confirmation_token(user) do
    user
    |> Guardian.encode_and_sign(%{}, token_type: "confirmation", ttl: @confirmation_token_ttl)
  end

  def encode_and_sign_refresh_token(user) do
    user
    |> Guardian.encode_and_sign(%{}, token_type: "refresh", ttl: @refresh_token_ttl)
  end

  def encode_and_sign_access_token(user) do
    user
    |> Guardian.encode_and_sign(%{}, token_type: "access", ttl: @access_token_ttl)
  end

  def exchange_refresh_for_access_token(refresh_token) do
    Guardian.exchange(refresh_token, "refresh", "access", ttl: @access_token_ttl)
    |> case do
      {:ok, _, {token, claims}} ->
        {:ok, %{token: token, claims: claims}}
      {:error, error} -> {:error, error}
    end
  end


  def send_user_confirmation_email({:ok, user}) do
    user
    |> encode_and_sign_confirmation_token()
    |> Tuple.append(user)
    |> create_user_confirmation_url()
    |> UserNotifier.deliver_confirmation_instructions()
  end

  def send_user_confirmation_email({:error, msg}) do
    {:error, msg}
  end

  def confirm_user({:ok, resource = %User{}}) do
    resource
    |> User.confirm_changeset()
    |> Repo.update()
    |> case do
      {:ok, user} -> {:ok, "#{user.email} confirmed at #{user.last_confirmed_at}"}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def confirm_user({:ok, claims}) do
    user = Guardian.resource_from_claims(claims)
    user
    |> confirm_user()
    user
  end

  def confirm_user({:error, msg}) do
    {:error, msg}
  end

  def handle_confirm_result({:ok, msg}, token) do
    Guardian.revoke(token)
    |> case do
      {:ok, _} -> {:ok, msg}
      {:error, msg} -> {:error, msg}
    end
  end

  def handle_confirm_result({:error, msg}, _) do
    {:error, msg}
  end

  def validate_user_confirmation_token(token) do
    Guardian.decode_and_verify(token, %{}, token_type: "confirmation")
    |> confirm_user()
  end

  def fetch_user_signin_tokens({:ok, user}) do
    user
    |> encode_and_sign_refresh_token()
  end

  def fetch_user_signin_tokens({:error, msg}) do
    {:error, msg}
  end

  def new_auth_blob(refresh_token) do
    refresh_token
    |> Guardian.decode_and_verify(%{}, token_type: "refresh")
    |> get_user_by_claims()
    |> fetch_user_signin_tokens()
  end

  def sign_in_user_by_token(token) do
    token
    |> validate_user_confirmation_token()
    |> fetch_user_signin_tokens()
  end

  def handle_user_confirmation(token) do
    token
    |> validate_user_confirmation_token()
  end

  def fetch_or_create_user(email) do
    case get_user_by_email(email) do
      {:ok, user} -> {:ok, user}
      {:error, _msg} -> create_user(%{email: email})
    end
  end

  def send_email_signin(email) do
    fetch_or_create_user(email)
    |> send_user_confirmation_email()
    |> case do
      {:ok, _} -> {:ok, "Confirmation email sent"}
      {:error, msg} -> {:error, msg}
    end
  end

  def create_user(attrs) do
    user_changeset = User.registration_changeset(%User{}, attrs)

    Multi.new()
    |> Multi.insert(:user, user_changeset)
    |> Multi.insert(:balance, fn %{user: user} ->
      Ecto.build_assoc(user, :balance)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, changes.user}
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  def renew_refresh_token(token) do
    Guardian.refresh(token, token_type: "refresh", ttl: @refresh_token_ttl)
    |> case do
      {:ok, {token, claims}, _} -> {:ok, %{token: token, claims: claims}}
      {:error, error} -> {:error, error}
    end
  end

  def revoke_refresh_token(token) do
    Guardian.revoke(token, token_type: "refresh")
  end

  def create_follow(follow_token, user) do
    case Guardian.resource_from_token(follow_token, %{}, token_type: "follow") do
      {:ok, followed, _} ->
        %Follow{}
        |> Ecto.Changeset.cast(%{}, [])
        |> Ecto.Changeset.cast_assoc(:follower, user)
        |> Ecto.Changeset.cast_assoc(:followed, followed)
        |> Repo.insert()
      {:error, _} -> {:error, "Invalid Token"}
    end
  end

  def get_user_by_email(email) do
    User
    |> where([u], u.email == ^email)
    |> Repo.one()
    |> case do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  def revoke_user_access_token(token) do
    Stat.Guardian.revoke(token)
  end

  def get_user_by_claims({:ok, claims}) do
    claims
    |> Stat.Guardian.resource_from_claims()
  end

  def get_user_by_claims({:error, _}) do
    {:error, "Invalid token"}
  end

  def renew_refresh_token(token) do
    Stat.Guardian.refresh(token, type: "refresh")
  end

  def get_user_by_token(token, type) do
    case Stat.Guardian.decode_and_verify(token, %{}, token_type: type) do
      {:ok, claims} ->
        claims
        |> Stat.Guardian.resource_from_claims()
      {:error, _} -> {:error, "Invalid token"}
    end
  end

  def get_user_by_token(nil, _) do
    {:error, "No token found"}
  end

  def get_user_by_token(token) do
    case Stat.Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        claims
        |> Stat.Guardian.resource_from_claims()
      {:error, _} -> {:error, "Invalid token"}
    end
  end

  def get_user_by_id(id, preload \\ []) do
    User
    |> where(id: ^id)
    |> Repo.preload(preload)
    |> Repo.one()
    |> case do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  def add_username(attrs, user) do
    user
    |> User.username_changeset(attrs)
    |> case do
      {:error, _} -> {:error, "Username already set"}
      changeset -> Repo.update(changeset)
    end
  end

  def add_avatar(attrs, user) do
    user
    |> Ecto.build_assoc(:avatar)
    |> Avatar.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_with_avatar(user) do
    avatar = Avatar |> where([a], a.user_id == ^user.id) |> limit(1) |> Repo.one()
    User
    |> where([u], u.id == ^user.id)
    |> Repo.one()
    |> case do
      nil -> {:error, "User not found"}
      user -> {:ok, Map.put(user, :public, %{avatar: avatar, username: user.username})}
    end
  end

  def get_follow_token(user) do
    Stat.Guardian.encode_and_sign(user, %{}, token_type: "follow", ttl: @default_follow_token_ttl)
    |> case do
      {:ok, token, _claims} -> {:ok, token}
      {:error, _} -> {:error, "Server error. Please try again later."}
    end
  end

  def get_followers(user) do
    {:ok, Follow
    |> where([f], f.followed_id == ^user.id)
    |> preload([:follower, follower: :avatar])
    |> Repo.all()
    |> Enum.map(fn f -> %{
      username: f.follower.username,
      avatar: f.follower.avatar }
    end) }
  end

  def get_following(user) do
    {:ok, Follow
    |> where([f], f.follower_id == ^user.id)
    |> preload([:followed, followed: :avatar])
    |> Repo.all()
    |> Enum.map(fn f -> %{
      username: f.followed.username,
      avatar: f.followed.avatar }
    end) }
  end
end
