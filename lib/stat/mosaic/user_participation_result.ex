defmodule Stat.Mosaic.UserParticipationResult do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mosaic_user_participation_results" do
    field :participation_count, :integer
    belongs_to :user, Stat.Accounts.User
    belongs_to :result, Stat.Mosaic.Result

    timestamps()
  end

  def changeset(user_participation_result, attrs) do
    user_participation_result
    |> cast(attrs, [:participation_count, :user_id, :result_id])
    |> validate_required([:participation_count, :user_id, :result_id])
  end
end
