defmodule StatWeb.WebappPlug do
  @behaviour Plug

  def init(_) do
    nil
  end

  def call(conn, _opts) do
    %{conn |
      request_path: "/webapp/index.html",
      path_info: ["webapp", "index.html"]
    }
  end
end
