defmodule StatWeb.ProfileController do
  use StatWeb, :controller

  alias Stat.Profiles


  def create(conn, %{"profile" => profile_params}) do
    case Profiles.create_profile(profile_params) do
      {:ok, _profile} ->
        conn
        |> put_flash(:info, "Profile created successfully.")
        |> redirect(to: ~p"/users/profile")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _) do
    profile = Profiles.edit_profile(conn.assigns.current_user.id)
    render(conn, :edit, changeset: profile)
  end

  def update(conn, %{"profile" => profile_params}) do
    case Profiles.update_profile(conn.assigns.current_user.id, profile_params) do
      {:ok, _profile} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: ~p"/users/profile")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, changeset: changeset)
    end
  end

  def show(conn, _) do
    IO.inspect(Profiles.get_profile(conn.assigns.current_user.id))
    conn
    |> render(:show, profile: Profiles.get_profile(conn.assigns.current_user.id))
  end
end
