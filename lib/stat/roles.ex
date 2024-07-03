defmodule Stat.Roles do
  import Ecto.Query, warn: false

  alias Stat.Repo
  alias Stat.Accounts.{User, Role}

  def make_user_admin(user_id) do
    Repo.get_by(Role, user_id: user_id)
    |> case do
      nil -> Role.changeset(%Role{}, %{user_id: user_id, name: "admin"}) |> Repo.insert()
      role -> Role.changeset(role, %{name: "admin"}) |> Repo.update()
    end
  end

  def is_admin?(user_id) do
    Repo.get_by(Role, user_id: user_id, name: "admin") != nil
  end
end
