defmodule Stat.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Stat.Repo

  alias Stat.Posts.{WeeklyCheckIn, Moment}

  ## Database getters
  def get_user_weeklycheckins(user_id) do
    Repo.all(from p in WeeklyCheckIn, where: p.user_id == ^user_id)
  end

  @spec get_user_moments(any()) :: any()
  def get_user_moments(user_id) do
    Repo.all(from m in Moment, where: m.user_id == ^user_id)
  end



  def create_weeklycheckin(attrs) do
    IO.inspect(attrs)
    %WeeklyCheckIn{}
    |> WeeklyCheckIn.changeset(attrs)
    |> Repo.insert!()
  end

  def create_moment(attrs) do
    %Moment{}
    |> Moment.changeset(attrs)
    |> Repo.insert()
    # Todo, take user to some page to add stickers
  end

  def is_currently_weeklycheckin_entry_time do
    day_of_week = :calendar.date_part(:weekday, :calendar.universal_time)

    # Users can submit weekly weeklycheckins between Friday and Monday
    if day_of_week >= 5 || day_of_week == 1 do
      true
    else
      false
    end
  end

  def check_user_entries(user_id, week_num, year) do
    Repo.all(
      from p in WeeklyCheckIn,
      where: p.user_id == ^user_id
            and p.week_number == ^week_num
            and p.year == ^year)
    |> Enum.count()
    |> case do
      0 -> {:ok, "No entries found"}
      1 -> {:error, "You have already submitted a weekly checkin for this week"}
      _ -> {:error, "You have already submitted a weekly checkin for this week"}
    end
  end

  def create_weekly_check_in(attrs) do
    %WeeklyCheckIn{}
    |> WeeklyCheckIn.changeset(attrs)
    |> Repo.insert()
  end

  # Next weeklycheckin is as follows:
  # * Users can submit weekly weeklycheckins between Friday and Monday
  # * Users can submit 1 weekly weeklycheckin per week
  def new_weeklycheckin_changeset(user_id) do
    with {week_num, year} <- :calendar.iso_week_number() do
      case check_user_entries(user_id, week_num, year) do
        {:ok, _} ->
          {
            :ok,
            %WeeklyCheckIn{}
            |> WeeklyCheckIn.new_weeklycheckin_changeset(%{
              "user_id" => user_id,
              "week_number" => week_num,
              "year" => year
            })
          }
        {:error, msg} ->
          {:error, msg}
      end
    end
  end
end
