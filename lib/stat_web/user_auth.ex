defmodule StatWeb.UserAuth do
  use StatWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias Stat.Accounts

  def log_in_user(conn, user) do
    token = Accounts.generate_user_session_token(user)

    conn
    |> put_req_header("authorization", "Bearer #{token}")
    |> redirect(~p"/webapp")
  end

  def fetch_user(conn, _opts) do
    with ["Bearer" <> token] <- get_req_header(conn, "authorization"),
      {:ok, user} <- Accounts.fetch_user_mobile_token(token) do
        assign(conn, :current_user, user)
      else
        _ ->
          conn
          |> send_resp(401, "Unauthorized")
          |> halt()
      end
  end
end
