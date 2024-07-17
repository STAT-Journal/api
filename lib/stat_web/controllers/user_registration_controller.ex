defmodule StatWeb.UserRegistrationController do
  use StatWeb, :controller

  require Ecto.Query
  alias Stat.{Accounts}

  def new(conn, _params) do
    changeset = Accounts.User.registration_changeset(%Accounts.User{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Accounts.create_user(%{email: email, password: password})
    |> case do
      {:ok, user} ->
        conn
        |> render(:confirmation, user: user)
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render(:new, changeset: changeset)
    end
  end
end
