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

  @renewal_token_ttl {1, :months} # Stored by clients and used to renew session tokens
  @session_token_ttl {3, :hours} # Used to authenticate requests
  @confirmation_token_ttl {30, :minutes} # Used to confirm user email


  @spec create_user_confirmation_url({:error, any(), any()} | {:ok, any(), any(), any()}) ::
          {:error, <<_::624>>} | {:ok, any(), <<_::64, _::_*8>>}
  def create_user_confirmation_url({:ok, token, _, user}) do
    {:ok, user, StatWeb.Endpoint.url() <> "/verify?token=#{token}"}
  end

  def create_user_confirmation_url({:error, error, _user}) do
    {:error, error}
  end

  def encode_and_sign_confirmation_token(user) do
    user
    |> Guardian.encode_and_sign(%{type: "confirmation"}, ttl: @confirmation_token_ttl)
    |> Tuple.append(user)
  end

  def encode_and_sign_renewal_token(user) do
    user
    |> Guardian.encode_and_sign(%{type: "renewal"}, ttl: @renewal_token_ttl)
    |> Tuple.append(user)
  end

  def encode_and_sign_session_token(user) do
    user
    |> Guardian.encode_and_sign(%{type: "session"}, ttl: @session_token_ttl)
    |> Tuple.append(user)
  end

  @spec send_user_confirmation_email({:error, any()} | {:ok, any()}) ::
          {:error, any()} | {:ok, Swoosh.Email.t()}
  def send_user_confirmation_email({:ok, user}) do
    user
    |> encode_and_sign_confirmation_token()
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
    Guardian.decode_and_verify(token, %{type: "confirmation"})
    |> confirm_user()
    |> handle_confirm_result(token)
  end

  def fetch_user_signin_tokens(user) do

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

  def refresh_user_session_token(token) do
    token
    |> Guardian.decode_and_verify(%{type: "session"})
    |> case do
      {:ok, _} -> Guardian.refresh(token, ttl: @session_token_ttl)
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

  def create_profile(attrs) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
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
