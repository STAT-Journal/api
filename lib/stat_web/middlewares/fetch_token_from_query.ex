defmodule StatWeb.Middlewares.FetchTokenFromQuery do
  import Plug.Conn
  import Phoenix.Controller

  def fetch_token_from_query(conn, _params) do
    case conn.query_params[:token] do
      nil -> conn |> redirect(to: "/verify/not_found") |> halt()
      token -> conn |> assign(:token, token)
    end
  end
end
