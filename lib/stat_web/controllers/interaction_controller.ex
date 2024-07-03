defmodule StatWeb.StickerController do
  use StatWeb, :controller

  def create(conn, %{"sticker" => sticker_params}) do
    case Stat.Posts.create_sticker(sticker_params) do
      {:ok, sticker} ->
        conn
        |> put_flash(:info, "Sticker created successfully!")
        |> redirect(to: Routes.sticker_path(conn, :show, sticker))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "error.html", changeset: changeset)
    end
  end
end
