defmodule StatWeb.PageController do
  use StatWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    case conn.assigns.current_user do
      nil ->
        conn
        |> render(
          :home
        )
      _ ->
        Stat.Posts.new_weeklycheckin_changeset(conn.assigns.current_user.id)
        |> case do
          {:ok, changeset} ->
            conn
            |> render(
              :home,
              periodic: changeset
            )
          {:error, _} ->
            conn
            |> render(
              :home,
              periodic: nil
            )

        end
    end
  end
end
