defmodule StatWeb.UserConfirmationController do
  use StatWeb, :controller

  alias Stat.Accounts

  def create(conn, %{"token" => token}) do
    case Accounts.validate_user_confirmation_token(token) do
      {:ok, user} ->
        conn
        |> render(:create, changeset: user)
      {:decode_error, _reason} ->
        conn
        |> render(:not_found)
      {:error, changeset} ->
        IO.inspect(changeset)
        conn
        |> render(:create, changeset: changeset)
    end
  end
end
