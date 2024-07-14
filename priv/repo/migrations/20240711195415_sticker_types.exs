defmodule Stat.Repo.Migrations.StickerTypes do
  use Ecto.Migration

  def change do
    create table(:sticker_types) do
      add :name, :string, null: false
      add :url, :string, null: false
      timestamps(type: :utc_datetime)
    end
  end
end
