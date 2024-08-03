defmodule StatWeb.Resolvers.Users do
  alias Stat.Accounts

  def get_user(_, _, %{context: %{current_user: user}}) do
    Accounts.get_user_with_avatar(user)
  end

  def get_user(_, _, _) do
    {:error, "Please log in first"}
  end

  def create_follow(_, %{followed_id: followed_id}, %{context: %{current_user: user}}) do
    args = %{followed_id: followed_id, follower_id: user.id}
    case Accounts.create_follow(args) do
      {:ok, follow} -> {:ok, follow}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def add_username(_, %{username: username}, %{context: %{current_user: user}}) do
    args = %{username: username}
    case Accounts.add_username(args, user) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def add_avatar(_, %{avatar: %{style: style, options: options}}, %{context: %{current_user: user}}) do
    args = %{style: style, options: options}
    case Accounts.add_avatar(args, user) do
      {:ok, avatar} -> {:ok, avatar}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
