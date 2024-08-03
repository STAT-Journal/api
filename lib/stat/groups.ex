defmodule Stat.Groups do
  alias Stat.Repo
  alias Stat.Groups.Group
  alias Stat.Accounts.User

  import Ecto.Query

  @active_period_days 1
  @group_size 5

  def create_group(users) do
    %Group{}
    |> Group.changeset(%{users: users})
    |> Repo.insert()
  end

  def create_groups do
    User
    |> where([u], u.last_confirmed_at > ago(@active_period_days, "day"))
    |> Repo.all()
    |> Enum.chunk_every(@group_size)
    |> Enum.map(&create_group/1)
  end

  def get_groups do
    Group
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def deactivate_group(group) do
    group
    |> Group.changeset(%{active: false})
    |> Repo.update()
  end

  def deactivate_groups do
    Group
    |> where([g], g.active == true and g.inserted_at < ago(@active_period_days, "day"))
    |> Repo.all()
    |> Enum.map(&deactivate_group/1)
  end
end
