defmodule Stat.Repo.Migrations.Test do
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
      add :token, :binary, null: false, size: 32
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])

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

    create table(:cities) do
      add :name, :string, null: false
      add :longitude, :float, null: false
      add :latitude, :float, null: false
      add :country, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:profiles) do
      add :username, :string, null: false
      add :city_id, references(:cities, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create table(:sticker_types) do
      add :name, :string, null: false
      add :url, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create table(:weekly_stickers) do
      add :weekly_check_in_id, references(:weekly_check_ins, on_delete: :delete_all), null: false
      add :sticker_type_id, references(:sticker_types, on_delete: :nothing), null: false
      timestamps(type: :utc_datetime)
    end

    create table(:moments) do
      add :type, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:moments, [:user_id])
  end
end
