defmodule Stat.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
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
  end
end
