defmodule StatWeb.Resolvers.Presences do
  def create_presence(_, _args, %{context: %{current_user: user}}) do
    {:ok, nil}
  end
end
