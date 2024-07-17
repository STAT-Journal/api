defmodule Stat.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias Stat.Repo
  alias Stat.Guardian
  import Stat.Queryable

  alias Stat.Accounts.{User, UserNotifier}

  @confirmation_token_ttl {30, :minutes}


  def create_user_confirmation_url(token) do
    "http://localhost:4000/confirm/#{token}"
  end

  def create_and_send_user_confirmation_token(user) do
    user
    |> Guardian.encode_and_sign(%{type: "confirmation", id: user.id}, ttl: @confirmation_token_ttl)
    |> case do
      {:ok, token, _claims} ->
        confirmation_url = create_user_confirmation_url(token)
        UserNotifier.deliver_confirmation_instructions(user, confirmation_url)
        {:ok, user}
      {:error, _} ->
        {:error, "Failed to generate confirmation token"}
    end
  end

  def confirm_user({:ok, user}) do
    user
    |> User.confirm_changeset()
    |> Repo.update()
    |> case do
      {:ok, user} ->
        {:ok, user}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def validate_user_confirmation_token(token) do
    Guardian.decode_and_verify(token, %{type: "confirmation"})
    |> case do
      {:ok, claims} ->
        claims
        |> Guardian.resource_from_claims()
        |> confirm_user()
      {:error, _} ->
        {:error, "Invalid confirmation token"}
    end
  end

  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        create_and_send_user_confirmation_token(user)
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def get_user_by_email(email) do
    User
    |> where([u], u.email == ^email)
    |> Repo.one()
  end

  def fetch_user_against_password(user, password) do
    if User.valid_password?(user, password) do
      user
    else
      nil
    end
  end

  def get_user_by_email_and_password(email, password) do
    get_user_by_email(email)
    |> Repo.one()
    |> fetch_user_against_password(password)
  end

  def generate_user_session_token(user) do
    Stat.Guardian.encode_and_sign(%{id: user.id})
  end

  def revoke_user_session_token(token) do
    Stat.Guardian.revoke(token)
  end

  def get_user_by_token(token) do
    case Stat.Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        User
        |> where([u], u.id == ^claims["id"])
        |> Repo.one()
      {:error, _} ->
        nil
    end
  end

  def get_user_by_id(id) do
    User
    |> where_id(id)
    |> Repo.one()
  end
end
