defmodule Stat.Posts.WeeklyCheckIn do
  use Ecto.Schema
  import Ecto.Changeset

  schema "weekly_check_ins" do
    field :anonymize, :boolean, default: true
    field :valence, Ecto.Enum, values: [:"😞", :"🙁", :"😐", :"🙂", :"😀"], null: false
    field :year, :integer
    field :week_number, :integer

    belongs_to :user, Stat.Accounts.User
    belongs_to :sticker_type, Stat.Consumables.StickerType # Optional

    many_to_many :stickers, Stat.Interactions.Sticker,
      join_through: "weekly_stickers"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(weeklycheckin, attrs) do
    weeklycheckin
    |> cast(attrs, [:anonymize, :valence, :week_number, :year, :sticker_type_id, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:anonymize, :valence, :week_number, :year, :user_id])
  end

  @spec new_weeklycheckin_changeset(
          {map(), map()}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def new_weeklycheckin_changeset(weekly_check_in, attrs) do
    weekly_check_in
    |> cast(attrs, [:user_id, :week_number, :year])
    |> cast_assoc(:user)
    |> validate_required([:user_id, :week_number, :year])
    |> maybe_validate_unique_weeklycheckin()
  end

  def maybe_validate_unique_weeklycheckin(weekly_check_in) do
    weekly_check_in
    |> unsafe_validate_unique([:user_id, :week_number, :year], Stat.Repo, message: "You have already submitted a weekly checkin for this week")
    |> unique_constraint([:user_id, :week_number, :year], message: "You have already submitted a weekly checkin for this week")
  end
end
