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

  def assign_current_user(conn, _error) do
    conn
  end

  def fetch_token(conn) do
    # Token can be in auth bearer header or cookie
    conn.req_cookies["token"] || get_req_header(conn, "authorization")
  end

  def fetch_user(conn, _opts) do
    with ["Bearer " <> token] <- fetch_token(conn) do
      user = Accounts.get_user_by_token(token)
      IO.inspect(user)
      user
    else
      _ -> {:error, "No token found"}
    end
  end
end
