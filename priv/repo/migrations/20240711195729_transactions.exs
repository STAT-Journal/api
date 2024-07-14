defmodule Stat.Repo.Migrations.Transactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :sticker_type_id, references(:sticker_types, on_delete: :nothing)
      add :change, :integer, null: false
      timestamps(type: :utc_datetime)
    end
  end
end
