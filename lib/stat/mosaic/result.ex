defmodule Stat.Mosaic.Result do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mosaic_results" do
    field :seed, :integer
    has_many :participations, Stat.Mosaic.UserParticipationResult
  end

  def changeset(result, attrs) do
    result
    |> cast(attrs, [:seed])
    |> validate_required([:seed])
  end
end
