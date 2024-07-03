defmodule StatWeb.PostWeeklyCheckInController do
  use StatWeb, :controller

  def new(conn, _params) do
    Stat.Posts.new_weeklycheckin_changeset(conn.assigns.current_user.id)
    |> case do
      {:ok, changeset} ->
        render(conn, :new, changeset: changeset)
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: ~p"/")
    end
  end

  def create(conn, %{"weekly_check_in" => weeklycheckin_params}) do
    weeklycheckin_params = Map.put(weeklycheckin_params, "user_id", conn.assigns.current_user.id)
    Stat.Posts.create_weeklycheckin(weeklycheckin_params)
    |> case do
      {:ok, _weekly_check_in} ->
        conn
        |> put_flash(:info, "Weekly check-in created successfully!")
        |> redirect(to: ~p"/posts/weeklycheckin")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :error, changeset: changeset)
    end
  end

  def list(conn, _params) do
    weekly_check_ins = Stat.Posts.get_user_weeklycheckins(conn.assigns.current_user.id)
    render(conn, :list, weekly_check_ins: weekly_check_ins)
  end

  def list_weeklycheckin_mobile(conn, _params) do
    weekly_check_ins = Stat.Posts.get_user_weeklycheckins(conn.assigns.current_user.id)
    conn |> json(weekly_check_ins)
  end

  def create_weeklycheckin_mobile(conn, %{"weekly_check_in" => weeklycheckin_params}) do
    weeklycheckin_params = Map.put(weeklycheckin_params, "user_id", conn.assigns.current_user.id)
    Stat.Posts.create_weeklycheckin(weeklycheckin_params)
    |> case do
      {:ok, weekly_check_in} ->
        conn
        |> json(weekly_check_in)
      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
    end
  end

  def list_moment_mobile(conn, _params) do
    moments = Stat.Posts.get_user_moments(conn.assigns.current_user.id)
    conn |> json(moments)
  end

  def create_moment_mobile(conn, %{"moment" => moment_params}) do
    moment_params = Map.put(moment_params, "user_id", conn.assigns.current_user.id)
    Stat.Posts.create_moment(moment_params)
    |> case do
      {:ok, moment} ->
        conn
        |> json(moment)
      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
    end
  end
end
