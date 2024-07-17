defmodule StatWeb.UserAuth do
  use StatWeb, :verified_routes

  import Plug.Conn

  alias Stat.Accounts

  def log_in_user(conn, user) do
    token = Accounts.generate_user_session_token(user)

    conn
    |> put_resp_cookie("token", token, http_only: true, secure: true)
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
