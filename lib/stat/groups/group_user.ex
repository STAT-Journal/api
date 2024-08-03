defmodule Stat.Groups.GroupUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_user" do
    belongs_to :group, Stat.Groups.Group
    belongs_to :user, Stat.Accounts.User

    timestamps()
  end
end
