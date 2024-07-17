defmodule Stat.Repo.Migrations.Follows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :follower_id, references(:profiles, on_delete: :delete_all)
      add :followed_id, references(:profiles, on_delete: :delete_all)

      timestamps()
    end

    create index(:follows, [:follower_id, :followed_id], unique: true)
  end
end
