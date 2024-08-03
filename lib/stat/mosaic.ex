defmodule Stat.Mosaic do
  import Ecto.Query

  alias Stat.Repo
  alias Stat.Mosaic.{Instance, UserInstance, Participation}

  def create_instance(users) do
    %Instance{}
    |> Ecto.build_assoc(:users, users)
    |> Instance.changeset(%{})
    |> Repo.insert()
  end

  def add_participation(instance, user) do
    %Participation{}
    |> Participation.changeset(%{mosaic_instance_id: instance.id, user_id: user.id})
  end
end
