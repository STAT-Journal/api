defmodule StatWeb.UserRegistrationController do
  use StatWeb, :controller

  require Ecto.Query
  alias Stat.Repo
  alias Stat.{Accounts, Profiles}
  alias Stat.Accounts.User
  alias StatWeb.UserAuth

  alias Ecto.Query
  alias Stat.Locations.City

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

          # Remove after cities are seeded
        Profiles.create_profile(%{
          user_id: user.id,
          username: "default",
          city_id: Repo.one(Query.from c in City, select: c.id)
        })

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
