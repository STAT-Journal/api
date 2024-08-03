defmodule Stat.Mosaic.Instance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mosaic_instance" do
    many_to_many :users, Stat.Accounts.User, join_through: Stat.Mosaic.UserInstance
    field :end_time, :utc_datetime
    field :result_image, :string # URL to image comprising all profile images (e.g. mosaic)

    timestamps()
  end

  def changeset(instance, attrs) do
    instance
    |> cast(attrs, [:end_time])
    |> validate_required([:end_time])
  end
end
