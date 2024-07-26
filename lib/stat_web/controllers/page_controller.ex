defmodule StatWeb.PageController do
  use StatWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout
    user_agent = conn |> Plug.Conn.get_req_header("user-agent")
    IO.inspect(user_agent)

    conn
    |> render(:home)
  end
end
