defmodule StatWeb.Resolvers.Auths do
  alias Stat.Accounts

  def renew_refresh_token(_, %{refresh_token: refresh_token}, _) do
    Accounts.renew_refresh_token(refresh_token)
    |> case do
      {:ok, %{token: token, claims: claims}}
      -> {:ok, %{token: token,
      claims: %{
        sub: claims["sub"],
        exp: claims["exp"],
        iat: claims["iat"]
      }}}
      {:error, reason} -> {:error, reason}
    end
  end

  def renew_refresh_token(_, _, _) do
    {:error, "Requires refresh token"}
  end

  def exchange_refresh_for_access_token(_, %{refresh_token: refresh_token}, _) do
    Accounts.exchange_refresh_for_access_token(refresh_token)
    |> case do
      {:ok, %{token: token, claims: claims}}
      -> {:ok, %{token: token,
      claims: %{
        sub: claims["sub"],
        exp: claims["exp"],
        iat: claims["iat"]
      }}}
      {:error, reason} -> {:error, reason}
    end
  end

  def exchange_refresh_for_access_token(_, _, _) do
    {:error, "Requires refresh token"}
  end

  def register(_, %{email: email}, _) do
    Accounts.send_email_signin(email)
  end
end
