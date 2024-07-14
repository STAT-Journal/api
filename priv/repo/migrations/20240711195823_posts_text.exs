defmodule Stat.Repo.Migrations.PostsText do
  use Ecto.Migration

  def change do
      create table(:texts) do
        add :body, :string
        add :user_id, references(:users, on_delete: :delete_all), null: false
        timestamps(type: :utc_datetime)
      end

      create index(:texts, [:user_id])
  end
end
