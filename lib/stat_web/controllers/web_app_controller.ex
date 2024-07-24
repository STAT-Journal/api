defmodule StatWeb.WebAppController do
  use StatWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout(false)
    |> put_resp_content_type("text/html")
    |> send_file(200, "priv/static/webapp/index.html")
  end
end
