defmodule StatWeb.Schemas.Presences do
  use Absinthe.Schema.Notation

  input_object :presence do
    field :number_of_engagements, :integer
    # TODO, location, etc.
  end
end
