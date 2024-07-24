defmodule StatWeb.UserConfirmationController do
  use StatWeb, :controller

  alias Stat.Accounts

  def create(conn, %{"token" => token}) do
    user_agent = conn.req_headers[:useragent]
    IO.inspect(user_agent)

    case Accounts.validate_user_confirmation_token(token) do
      {:ok, _user} ->
        conn
        |> redirect(to: ~p"/webapp/token")

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
