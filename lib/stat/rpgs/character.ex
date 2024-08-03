defmodule Stat.Rpg.Character do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rpg_characters" do
    belongs_to :user, Stat.Accounts.User
  end

end
