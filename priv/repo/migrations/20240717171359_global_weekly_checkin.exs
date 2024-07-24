defmodule Stat.Repo.Migrations.GlobalWeeklyCheckin do
  use Ecto.Migration

  def change do
    create table(:global_weekly_checkins) do
      add :year, :integer
      add :week_number, :integer

      add :total_checkins, :integer
      add :total_valence, :integer
      add :average_valence, :integer
      add :median_valence, :integer

      timestamps()
    end

    create unique_index(:global_weekly_checkins, [:year, :week_number])
  end
end
