defmodule StatWeb.Resolvers.Users do
  alias Stat.Accounts

  def get_user(_, _, %{context: %{current_user: user}}) do
    Accounts.get_user_with_avatar(user)
  end

  def get_user(_, _, _) do
    {:error, "Please log in first"}
  end

  def get_follow_token(_, _, %{context: %{current_user: user}}) do
    Accounts.get_follow_token(user)
  end

  def get_follow_token(_, _, _) do
    {:error, "Please log in first"}
  end

  def create_follow(_, %{follow_token: follow_token}, %{context: %{current_user: user}}) do
    Accounts.create_follow(follow_token, user)
  end

  def create_follow(_, _, _) do
    {:error, "Please log in first"}
  end

  def get_followers(_, _, %{context: %{current_user: user}}) do
    result = Stat.Accounts.get_followers(user)
    IO.inspect(result)
    result
  end

  def get_followers(_, _, _) do
    {:error, "Please log in first"}
  end

  def get_following(_, _, %{context: %{current_user: user}}) do
    Accounts.get_following(user)
  end

  def get_following(_, _, _) do
    {:error, "Please log in first"}
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
