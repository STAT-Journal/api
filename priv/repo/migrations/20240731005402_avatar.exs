defmodule Stat.Repo.Migrations.Avatar do
  use Ecto.Migration

  def change do
    create table(:avatars) do
      add :version, :enum, values: ["9.x"], default: "9.x"
      add :style, :string
      add :options, :string

      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end

    create unique_index(:avatars, [:user_id])
  end
end
