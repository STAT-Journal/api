defmodule StatWeb.UserSessionController do
  use StatWeb, :controller

  import Plug.Conn

  alias Stat.Accounts

  def create_by_email_and_password(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> send_resp(401, "Unauthorized")
        |> halt()
      user ->
        token = Accounts.generate_user_session_token(user)
        conn
        |> put_resp_cookie("token", token, http_only: true, secure: true)
        |> put_status(201)
    end
  end
end
