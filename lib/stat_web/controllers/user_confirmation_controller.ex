defmodule StatWeb.UserConfirmationController do
  use StatWeb, :controller

  alias Stat.Accounts

  def create(conn, %{"token" => token}) do
    case Accounts.validate_user_confirmation_token(token) do
      {:ok, user} ->
        conn
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> redirect(to: "/")
    end
  end
end
