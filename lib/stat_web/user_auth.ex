defmodule StatWeb.UserAuth do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    user = fetch_user(conn, opts)
    assign_current_user(conn, user)
  end

  def assign_current_user(conn, {:ok, user}) do
    Absinthe.Plug.put_options(conn, context: %{current_user: user})
  end

  def assign_current_user(conn, {:error, "No token found"}) do
    conn
  end

  def assign_current_user(conn, {:error, _}) do
    Absinthe.Plug.put_options(conn, context: %{current_user: :error})
  end

  def fetch_token(conn) do
    get_req_header(conn, "authorization")
  end

  def fetch_user(conn, _opts) do
    with ["Bearer " <> token] <- fetch_token(conn) do
      case Stat.Accounts.get_user_by_token(token, "access") do
        {:ok, user} -> {:ok, user}
        {:error, _} -> {:error, "Invalid token"}
      end
    else
      _ -> {:error, "No token found"}
    end
  end
end
