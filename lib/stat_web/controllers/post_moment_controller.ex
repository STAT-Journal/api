defmodule StatWeb.PostMomentController do
  use StatWeb, :controller

  alias Stat.Posts.{Moment}
  alias Stat.Consumables.StickerType


  def create(conn, %{"moment" => moment_params}) do
    moment_params
    |> Map.put("user_id", conn.assigns.current_user.id)
    |> Stat.Posts.create_moment()
    |> case do
      {:ok, _moment} ->
        conn
        |> put_flash(:info, "Moment created successfully!")
        |> redirect(to: ~p"/")
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, changeset.errors)
        |> redirect(to: ~p"/")
    end
  end

  def list(conn, _params) do
    moments = Stat.Posts.get_user_moments(conn.assigns.current_user.id)
    render(conn, :list, moments: moments)
  end
end
