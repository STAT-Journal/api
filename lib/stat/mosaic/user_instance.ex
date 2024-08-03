defmodule Stat.Mosaic.UserInstance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mosaic_user_instance" do
    belongs_to :user, Stat.Accounts.User
    belongs_to :instance, Stat.Mosaic.Instance

    timestamps()
  end
end
