defmodule StatWeb.WebAppController do
  use StatWeb, :controller

  @index_path Application.app_dir(:stat, "priv/static/webapp")

  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, @index_path <> "/index.html")
  end
end
