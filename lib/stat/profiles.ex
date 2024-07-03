defmodule Stat.Profiles do
  import Ecto.Query, warn: false
  alias Stat.Repo

  alias Stat.Accounts.{Profile}

  def get_profile(user_id) do
    Repo.one(from p in Profile, where: p.user_id == ^user_id, preload: [:city])
  end

  def create_profile(attrs) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  @spec edit_profile(any()) :: Ecto.Changeset.t()
  def edit_profile(user_id) do
    get_profile(user_id)
    |> Profile.changeset(%{})
  end

  def update_profile(user_id, attrs) do
    get_profile(user_id)
    |> Profile.changeset(attrs)
    |> Repo.update()
  end
end
