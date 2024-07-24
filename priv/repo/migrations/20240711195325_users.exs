defmodule Stat.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false, collate: :nocase
      add :last_confirmed_at, :utc_datetime
      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])

    create table(:cities) do
      add :name, :string, null: false
      add :longitude, :float, null: false
      add :latitude, :float, null: false
      add :country, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:profiles) do
      add :username, :string, null: false
      add :city_id, references(:cities, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end
  end
end
