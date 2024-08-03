defmodule Stat.Rpgs.Action do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rpg_actions" do
    field :name, Ecto.Enum, values: [:music, :rest, :listen, :cook]
  end

end
