defmodule StatWeb.Resolvers.Users do
  alias Stat.Accounts

  def get_user(%{context: %{current_user: user}}) do
    {:ok, user}
  end

  def get_user(_, _, _) do
    {:error, "Please log in first"}
  end

  def get_profile(%{id: id}) do
    Accounts.get_profile(id)
  end

  def create_profile(_, %{username: username}, %{context: %{current_user: user}}) do
    attrs = %{username: username, user_id: user.id}
    case Accounts.create_profile(attrs) do
      {:ok, persona} -> {:ok, persona}
      {:error, changeset} -> {:error, changeset}
    end
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
