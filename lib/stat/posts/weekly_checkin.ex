defmodule Stat.Posts.WeeklyCheckIn do
  use Ecto.Schema
  import Ecto.Changeset

  schema "weekly_check_ins" do
    field :anonymize, :boolean, default: true
    field :valence, Ecto.Enum, values: [:"😞", :"🙁", :"😐", :"🙂", :"😀"], null: false

    belongs_to :user, Stat.Accounts.User
    belongs_to :sticker_type, Stat.Consumables.StickerType # Optional
    belongs_to :global_weekly_checkin, Stat.Meta.GlobalWeeklyCheckin

    timestamps(type: :utc_datetime)
  end

  def unsafe_changeset(weeklycheckin, attrs) do
    weeklycheckin
    |> cast(attrs, [:user_id, :global_weekly_checkin_id])
    |> unsafe_validate_unique([:user_id, :global_weekly_checkin_id], Stat.Repo, message: "You have already checked in this week")
  end

  @doc false
  def changeset(weeklycheckin, attrs) do
    weeklycheckin
    |> cast(attrs, [
      :anonymize,
      :valence,
      :sticker_type_id,
      :user_id,
      :global_weekly_checkin_id])
    |> cast_assoc(:user)
    |> cast_assoc(:sticker_type)
    |> cast_assoc(:global_weekly_checkin)
    |> validate_required([:anonymize, :valence, :user_id, :global_weekly_checkin_id])
    |> unique_constraint([:user_id, :global_weekly_checkin_id], message: "You have already checked in this week")
  end
end
