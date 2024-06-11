defmodule StatWeb.HelloHTML do
  use StatWeb, :html

  def index(assigns) do
    ~H"""
    Hello from API!
    """
  end
end
