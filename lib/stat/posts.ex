defmodule Stat.Posts do
  import Ecto.Query, warn: false
  alias Stat.Repo
  import Stat.Queryable
  import Stat.Deletable

  alias Stat.Posts.{Text, Moment, WeeklyCheckIn}
  alias Stat.Meta.GlobalWeeklyCheckin

  def create_text_post(args) do
    %Text{}
    |> Text.changeset(args)
    |> Repo.insert()
  end

  def update_text_post(args) do
    Text
    |> where(id: ^args.id)
    |> where(user_id: ^args.user_id)
    |> Text.changeset(args)
    |> Repo.update()
  end

  def list_text_posts(user) do
    Text
    |> where(user_id: ^user.id)
    |> where_not_deleted()
    |> Repo.all()
  end

  def list_deleted_text_posts(user) do
    Text
    |> where(user_id: ^user.id)
    |> where_deleted()
    |> Repo.all()
  end

  def delete_text_post(args) do
    Text
    |> where(id: ^args.id, user_id: ^args.user.id)
    |> where_not_deleted()
    |> Repo.one()
    |> case do
      nil -> {:error, "Text post not found"}
      text_post ->
        text_post
        |> delete_changeset()
        |> Repo.update()
    end
  end

  def undelete_text_post(args) do
    Text
    |> where(id: ^args.id, user_id: ^args.user.id)
    |> where_deleted()
    |> Repo.one()
    |> case do
      nil -> {:error, "Text post not found"}
      text_post ->
        text_post
        |> undelete_changeset()
        |> Repo.update()
    end
  end

  def list_moments do
    Moment
    |> where_not_deleted()
    |> Repo.all()
  end

  def list_moments(user) do
    list_moments()
    |> where(user_id: ^user.id)
    |> Repo.all()
  end

  def create_moment(args) do
    %Moment{}
    |> Moment.changeset(args)
    |> Repo.insert()
  end

  # TODO, put this on cache
  def latest_global_checkin do
    GlobalWeeklyCheckin
    |> order_by(desc: :year)
    |> order_by(desc: :week_number)
    |> limit(1)
    |> Repo.one()
  end

  def unsafe_check_if_user_can_check_in(user) do
    case latest_global_checkin() do
      nil -> {:error, "No global checkin found"}
      global_checkin ->
        args = %{user_id: user.id, global_weekly_checkin_id: global_checkin.id}
        check = %WeeklyCheckIn{}
        |> WeeklyCheckIn.unsafe_changeset(args)

        {:ok, check.valid?}
    end
  end

  def create_weekly_checkin(args) do
    latest_global_checkin()
    |> case do
      nil -> {:error, "No global checkin found"}
      global_checkin ->
        args = %{global_weekly_checkin_id: global_checkin.id}
        |> Map.merge(args)

        %WeeklyCheckIn{}
        |> WeeklyCheckIn.changeset(args)
        |> Repo.insert()
    end
  end
end
