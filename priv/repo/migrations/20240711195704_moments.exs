defmodule Stat.Repo.Migrations.Moments do
  use Ecto.Migration

  def change do
    create table(:moments) do
      add :type, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:moments, [:user_id])
  end
end
