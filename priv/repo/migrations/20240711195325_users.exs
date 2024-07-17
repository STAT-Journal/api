defmodule Stat.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false, collate: :nocase
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])

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


    create table(:roles) do
      add :name, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:roles, [:user_id])
  end
end
