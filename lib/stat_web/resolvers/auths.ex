defmodule StatWeb.Resolvers.Auths do
  alias Stat.Accounts

  def check_renewal_token(_, %{renewal_token: renewal_token}, _) do
    case Accounts.get_user_by_renewal_token(renewal_token, "renewal") do
      {:ok, user} -> {:ok, user}
      {:error, _} -> {:error, "Invalid renewal token"}
    end
  end

  def email_to_renewal_token(_, %{email_token: email_token, device_name: device_name}, _) do
    case Accounts.get_user_by_token(email_token, "email") do
      {:ok, user} ->
        {:ok, Accounts.generate_user_renewal_token(user, device_name)}
      {:error, _} ->
        {:error, "Invalid email token"}
    end
  end

  def retrieve_renewal_token(_, %{email: email, password: password, device_name: device_name}, _) do
    case Accounts.fetch_user_against_password(email, password) do
      {:ok, user} ->
        {:ok, Accounts.generate_user_renewal_token(user, device_name)}
      {:error, _} ->
        {:error, "Invalid email or password"}
    end
  end

  def refresh_renewal_token(_, %{renewal_token: renewal_token}, _) do
    case Accounts.refresh_user_renewal_token(renewal_token) do
      {:ok, token} -> {:ok, token}
      {:error, _} -> {:error, "Invalid renewal token"}
    end
  end

  def check_session_token(_, %{session_token: session_token}, _) do
    case Accounts.get_user_by_token(session_token, "session") do
      {:ok, user} -> {:ok, user}
      {:error, _} -> {:error, "Invalid session token"}
    end
  end

  def get_session_token(_, %{renewal_token: renewal_token}, _) do
    case Accounts.get_session_token_from_renewal_token(renewal_token) do
      {:ok, token} -> {:ok, token}
      {:error, _} -> {:error, "Invalid renewal token"}
    end
  end

  def register(_, %{email: email}, _) do
    Accounts.send_email_signin(email)
  end
end
