defmodule StatWeb.Resolvers.Users do
  alias Stat.Accounts

  def get_user(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def get_user(_, _, _) do
    {:error, "Please log in first"}
  end

  def get_profile(%{id: id}) do
    Accounts.get_profile(id)
  end

  def create_profile(_, args = %{username: _username, avatar: _avatar}, %{context: %{current_user: user}}) do
    Accounts.create_profile(args, user)
  end

  def create_profile(_, _, _) do
    {:error, "Please log in first"}
  end

  def create_follow(_, %{followed_id: followed_id}, %{context: %{current_user: user}}) do
    args = %{followed_id: followed_id, follower_id: user.id}
    case Accounts.create_follow(args) do
      {:ok, follow} -> {:ok, follow}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
