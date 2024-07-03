defmodule Stat.Consumables.StickerType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sticker_types" do
    field :name, :string
    field :url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sticker_type, attrs) do
    sticker_type
    |> cast(attrs, [:name, :url])
    |> validate_required([:name, :url])
  end
end
