defmodule StatWeb.HelloController do
  use StatWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
