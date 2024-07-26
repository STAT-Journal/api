defmodule StatWeb.UserConfirmationController do
  use StatWeb, :controller

  alias Stat.Accounts

  def create(conn, %{"token" => token}) do
    case Accounts.sign_in_user_by_token(token) do
      {:ok, result} ->
        redirect_query_params = URI.encode_query(%{
          renewal_token: result.renewal_token,
          renewal_expiration: result.renewal_expirary,
          session_token: result.session_token,
          session_expiration: result.session_expirary
        })
        conn
        |> put_resp_cookie("renewal_token", result.renewal_token, http_only: true, secure: true)
        |> put_resp_cookie("renewal_expiration", result.renewal_expirary, http_only: true, secure: true)
        |> put_resp_cookie("session_token", result.session_token, http_only: true, secure: true)
        |> put_resp_cookie("session_expiration", result.session_expirary, http_only: true, secure: true)
        |> redirect(external: "http://localhost:5173/webapp/login/token" <> "?" <> redirect_query_params)

      {:error, _reason} ->
        conn
        |> redirect(to: ~p"/verify/not_found")
    end
  end

  def not_found(conn, _params) do
    conn
    |> put_status(404)
    |> render(:not_found)
  end
end
