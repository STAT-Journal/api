defmodule StatWeb.WebAppController do
  use StatWeb, :controller

  def desktop_redirect_base do
    Application.get_env(:stat, StatWeb.UserConfirmationController)[:desktop_redirect_base]
    || ~p"/webapp/login/token"
  end

  def index(conn, _params) do
    case desktop_redirect_base() do
      path = "http" <> _ ->
        conn
        |> redirect(external: path)
      path ->
        conn
        |> put_resp_content_type("text/html")
        |> send_file(200, Application.app_dir(:stat, "priv/static/webapp/index.html"))
      end
  end
end
