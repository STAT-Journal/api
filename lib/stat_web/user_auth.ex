defmodule StatWeb.UserAuth do
  @behaviour Plug

  import Plug.Conn

  alias Stat.Accounts

  def init(opts), do: opts

  def call(conn, opts) do
    user = fetch_user(conn, opts)
    assign_current_user(conn, user)
  end


  def assign_current_user(conn, {:ok, user}) do
    Absinthe.Plug.put_options(conn, context: %{current_user: user})
  end

  def assign_current_user(conn, {:error, "Invalid token"}) do
    conn
    |> Absinthe.Plug.put_options(context: %{current_user: :error})
  end

  def assign_current_user(conn, _error) do
    conn
  end

  def fetch_token(conn) do
    # Token can be in auth bearer header or cookie
    conn.req_cookies["token"]
    || get_req_header(conn, "authorization")
    || get_req_header(conn, "Authorization")
  end

  def fetch_user(conn, _opts) do
    with ["Bearer " <> token] <- fetch_token(conn) do
      user = Accounts.get_user_by_token(token)
      user
    else
      _ -> {:error, "No token found"}
    end
  end
end
