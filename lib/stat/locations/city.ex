defmodule Stat.Locations.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cities" do
    field :name, :string
    field :longitude, :float
    field :latitude, :float
    field :country, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name, :url, :country, :longitude, :latitude])
    |> validate_required([:name, :url, :country, :longitude, :latitude])
  end
end
