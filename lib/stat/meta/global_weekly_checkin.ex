defmodule Stat.Meta.GlobalWeeklyCheckin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "global_weekly_checkins" do
    field :year, :integer
    field :week_number, :integer

    has_many :weekly_checkins, Stat.Posts.WeeklyCheckIn

    field :total_checkins, :integer
    field :total_valence, :integer
    field :average_valence, :integer
    field :median_valence, :integer
  end

  @doc false
  # Create at the start of the week
  def changeset(global_weekly_checkin, attrs) do
    global_weekly_checkin
    |> cast(attrs, [:year, :week_number])
    |> validate_required([:year, :week_number])
    |> unique_constraint([:year, :week_number])
  end

  def end_of_week_changeset(global_weekly_checkin, attrs) do
    global_weekly_checkin
    |> cast(attrs, [:total_checkins, :total_valence, :average_valence, :median_valence])
    |> validate_required([:total_checkins, :total_valence, :average_valence, :median_valence])
  end
end
