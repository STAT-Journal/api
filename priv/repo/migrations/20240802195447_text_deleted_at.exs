defmodule Stat.Repo.Migrations.TextDeletedAt do
  use Ecto.Migration

  def change do
    alter table(:texts) do
      add :deleted_at, :utc_datetime
    end
  end
end
