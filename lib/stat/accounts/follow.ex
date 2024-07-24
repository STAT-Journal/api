defmodule Stat.Accounts.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  schema "follows" do
    belongs_to :follower, Stat.Accounts.Profile
    belongs_to :followed, Stat.Accounts.Profile
  end

  def validate_follow_ids(changeset) do
    follower_id = get_field(changeset, :follower_id)
    followed_id = get_field(changeset, :followed_id)
    if follower_id == followed_id do
      add_error(changeset, :follower_id, "Follower and followed cannot be the same")
    else
      changeset
    end
  end

  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [:follower_id, :followed_id])\
    |> validate_required([:follower_id, :followed_id])
    |> validate_follow_ids()
    |> cast_assoc(:follower)
    |> cast_assoc(:followed)
  end
end
