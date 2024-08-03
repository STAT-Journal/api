defmodule StatWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket,
    schema: StatWeb.Schema


  def connect(params, socket) do
    current_user(params)
    |> case do
      {:ok, current_user} ->
        socket = Absinthe.Phoenix.Socket.put_options(socket, context: %{
          current_user: current_user
        })
        socket = Phoenix.Socket.assign(socket, %{
          context: %{
            current_user: current_user
          }
        })
        IO.inspect("User #{current_user.id} connected")
        {:ok, socket}
      {:error, _} ->
        {:error, :unauthorized}
    end
  end

  defp current_user(%{"token" => token}) do
    Stat.Accounts.get_user_by_token(token, "access")
  end

  defp current_user(_params) do
    {:ok , %Stat.Accounts.User{id: 1}}
  end

  def id(socket) do
    "user_socket-#{socket.assigns.context.current_user.id}"
  end
end
