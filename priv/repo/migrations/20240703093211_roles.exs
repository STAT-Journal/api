defmodule Stat.Repo.Migrations.Roles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:roles, [:user_id])
  end
end
