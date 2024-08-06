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
    {:ok, Text
    |> where(user_id: ^user.id)
    |> where_not_deleted()
    |> order_by(desc: :inserted_at)
    |> Repo.all() }
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
    |> Repo.all()
  end

  def list_moments(user) do
    {:ok, Moment
    |> where(user_id: ^user.id)
    |> order_by(desc: :inserted_at)
    |> limit(10)
    |> Repo.all()
    |> Enum.map(&Map.put(&1, :inserted_at, DateTime.to_iso8601(&1.inserted_at)))
    }
  end

  def list_moments_for_graph(user) do
    result = Moment
    |> where(user_id: ^user.id)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> Enum.chunk_by(fn m -> {m.inserted_at.year, m.inserted_at.month, m.inserted_at.day} end)
    |> Enum.map(fn chunk ->
      inserted_at = DateTime.to_iso8601(Enum.at(chunk, 0).inserted_at)
      Enum.chunk_by(chunk, fn c -> c.type end)
      |> Enum.map(fn c -> {Enum.at(c, 0).type, Enum.count(c)} end)
      |> Map.new()
      |> Map.put(:inserted_at, inserted_at)
    end)

    IO.inspect(result)

    {:ok, result}
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
