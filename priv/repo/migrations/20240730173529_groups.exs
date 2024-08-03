defmodule Stat.Repo.Migrations.Groups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :active, :boolean, default: true
      timestamps()
    end

    create table(:group_user, primary_key: false) do
      add :group_id, references(:groups, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
