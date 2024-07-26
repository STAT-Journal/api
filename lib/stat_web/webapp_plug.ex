defmodule StatWeb.WebappPlug do
  @behaviour Plug

  def init(_) do
    nil
  end

  def call(conn, _opts) do

    # If the request path is /webapp or /webapp/* (regex), rewrite the request path to /webapp/index.html
    case Regex.match?(~r{^/webapp(/[a-zA-Z]*)?$}, conn.request_path) do
      true ->
        %{conn |
          request_path: "/webapp/index.html",
          path_info: ["webapp", "index.html"]
        }
      false -> conn
    end
  end
end
