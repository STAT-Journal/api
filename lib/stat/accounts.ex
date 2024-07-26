defmodule Stat.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias Stat.Consumables.Balance
  alias Ecto.Multi
  alias Stat.Repo
  alias Stat.Guardian

  alias Stat.Consumables.{Balance}
  alias Stat.Accounts.{User, UserNotifier, Profile, Follow}

  @renewal_token_ttl {4, :weeks} # Stored by clients and used to renew session tokens
  @session_token_ttl {3, :hours} # Used to authenticate requests
  @confirmation_token_ttl {30, :minutes} # Used to confirm user email



  def create_user_confirmation_url({:ok, token, _, user}) do
    {:ok, user, StatWeb.Endpoint.url() <> "/verify?token=#{token}"}
  end

  def create_user_confirmation_url({:error, error, _user}) do
    {:error, error}
  end

  def encode_and_sign_confirmation_token(user) do
    user
    |> Guardian.encode_and_sign(%{type: "confirmation"}, ttl: @confirmation_token_ttl)
  end

  def encode_and_sign_renewal_token(user) do
    user
    |> Guardian.encode_and_sign(%{type: "renewal"}, ttl: @renewal_token_ttl)
  end

  def encode_and_sign_session_token(user) do
    user
    |> Guardian.encode_and_sign(%{type: "session"}, ttl: @session_token_ttl)
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
      {:ok, user} -> {:ok, "User confirmed at #{user.last_confirmed_at}"}
      {:error, changeset} -> {:confirm_error, changeset}
    end
  end

  def confirm_user({:ok, claims}) do
    Guardian.resource_from_claims(claims)
    |> confirm_user()
  end

  def confirm_user({:error, msg}) do
    {:error, msg}
  end

  @spec handle_confirm_result({:error, any()} | {:ok, any()}, any()) ::
          {:error, any()} | {:ok, any()}
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
    user = token |> get_user_by_token()
    Guardian.decode_and_verify(token, %{type: "confirmation"})
    |> confirm_user()
    |> handle_confirm_result(token)
    user
  end

  def fetch_user_signin_tokens({:ok, user}) do
    renewal_result = user |> encode_and_sign_renewal_token()
    session_result = user |> encode_and_sign_session_token()

    case {renewal_result, session_result} do
      {{:ok, renewal_token, renewal_claims}, {:ok, session_token, session_claims}} ->
        renewal_expirary = renewal_claims |> Map.get("exp")
        session_expirary = session_claims |> Map.get("exp")
        {:ok, %{
          renewal_token: renewal_token,
          renewal_expirary: renewal_expirary,
          session_token: session_token,
          session_expirary: session_expirary
        }}
      {{:error, msg}, _} -> {:error, msg}
      {_, _} -> {:error, "Unknown error"}
    end
  end

  def fetch_user_signin_tokens({:error, msg}) do
    {:error, msg}
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

  def revoke_renewal_token(token) do
    Guardian.decode_and_verify(token, %{type: "renewal"})
    |> case do
      {:ok, _} ->
        Guardian.revoke(token)
      {:error, _} ->
        {:error, "Invalid token"}
    end
  end

  def create_follow(attrs) do
    %Follow{}
    |> Follow.changeset(attrs)
    |> Repo.insert()
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

  def refresh_user_renewal_token(token) do
    token
    |> Guardian.decode_and_verify(%{type: "renewal"})
    |> case do
      {:ok, _} -> Guardian.refresh(token, ttl: @renewal_token_ttl)
      {:error, _} -> {:error, "Invalid token"}
    end
  end

  def get_session_token_from_renewal_token(token) do
    case Stat.Guardian.decode_and_verify(token, %{type: "renewal"}) do
      {:ok, claims} ->
        claims
        |> Stat.Guardian.resource_from_claims()
        |> encode_and_sign_session_token()
      {:error, _} -> {:error, "Invalid token"}
    end
  end

  def revoke_user_session_token(token) do
    Stat.Guardian.revoke(token)
  end

  def get_user_by_token(token, type) do
    case Stat.Guardian.decode_and_verify(token, %{type: type}) do
      {:ok, claims} ->
        claims
        |> Stat.Guardian.resource_from_claims()
      {:error, _} -> {:error, "Invalid token"}
    end
  end

  def get_user_by_token(token) do
    case Stat.Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        claims
        |> Stat.Guardian.resource_from_claims()
      {:error, _} -> {:error, "Invalid token"}
    end
  end

  def get_user_by_id(id) do
    User
    |> where(id: ^id)
    |> Repo.one()
    |> case do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  def create_profile(attrs, user) do
    user
    |> Ecto.build_assoc(:profile)
    |> Profile.changeset(attrs)
  end

  def get_profile(id) do
    Profile
    |> where(id: ^id)
    |> Repo.one()
    |> case do
      nil -> {:error, "Profile not found"}
      profile -> {:ok, profile}
    end
  end

  def get_main_profile(user) do
    User
    |> where(id: ^user.id)
    |> Repo.preload(:main_profile)
    |> Repo.one()
    |> case do
      nil -> {:ok, nil}
      user -> {:ok, user.main_profile}
    end
  end

  def user_owns_profile(profile_id, user) do
    Profile
    |> where([p], p.id == ^profile_id and p.user_id == ^user.id)
    |> Repo.one()
    |> case do
      nil -> {:error, "Profile not found"}
      profile -> {:ok, profile}
    end
  end
end
