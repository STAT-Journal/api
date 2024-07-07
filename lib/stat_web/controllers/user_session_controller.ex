defmodule StatWeb.UserSessionController do
  use StatWeb, :controller

  alias Stat.Accounts
  alias StatWeb.UserAuth

  import Plug.Conn

  def new(conn, _params) do
    render(conn, :new, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, "Welcome back!")
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, :new, error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end

  # For mobile apps
  def create_mobile(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      token = Accounts.create_user_mobile_token(user)
      conn
      |> json(%{
        user: %{
          email: user.email
        },
        token: token
        })

    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Invalid email or password"})
    end
  end


  def delete_mobile(conn, %{"token" => token}) do
    with {:ok, _user} <- Accounts.fetch_user_mobile_token(token) do
      Accounts.delete_user_mobile_token(token)
      conn |> json(%{message: "Logged out successfully"})
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid token"})
    end
  end
end
