defmodule Stat.Rpgs.CareRecipient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rpg_care_recipients" do
    field :name, :string
    field :health, :integer
  end

end
