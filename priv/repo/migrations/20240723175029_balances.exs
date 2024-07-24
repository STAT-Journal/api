defmodule Stat.Repo.Migrations.Balances do
  use Ecto.Migration

  def change do
    create table(:balances) do
      add :balance, :integer, default: 0
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:balances, [:user_id])
  end
end
