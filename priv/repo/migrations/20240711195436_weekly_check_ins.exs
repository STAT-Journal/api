defmodule Stat.Repo.Migrations.WeeklyCheckIns do
  use Ecto.Migration

  def change do
    create table(:weekly_check_ins) do
      add :anonymize, :boolean, default: true, null: false
      add :valence, :string, null: false
      add :week_number, :integer, null: false
      add :year, :integer, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :sticker_type_id, references(:sticker_types, on_delete: :nothing)
      timestamps(type: :utc_datetime)
    end

    create index(:weekly_check_ins, [:user_id])
    create unique_index(:weekly_check_ins, [:user_id, :week_number, :year])

    create table(:weekly_stickers) do
      add :weekly_check_in_id, references(:weekly_check_ins, on_delete: :delete_all), null: false
      add :sticker_type_id, references(:sticker_types, on_delete: :nothing), null: false
      timestamps(type: :utc_datetime)
    end
  end
end
