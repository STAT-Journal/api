defmodule StatWeb.Resolvers.Users do
  alias Stat.Accounts

  def get_user(_, _, %{current_user: user}) do
    {:ok, user}
  end

  def get_user(_, _, _) do
    {:error, "Please log in first"}
  end

  def create_profile(_, %{username: username}, %{context: %{current_user: user}}) do
    case Accounts.create_profile(%{username: username}, user) do
      {:ok, persona} -> {:ok, persona}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def create_profile(_, _, _) do
    {:error, "Please log in first"}
  end

  def create_follow(_, %{followed_id: followed_id}, %{context: %{current_user: user}}) do
    case Accounts.create_follow(%{followed_id: followed_id}, user) do
      {:ok, follow} -> {:ok, follow}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
