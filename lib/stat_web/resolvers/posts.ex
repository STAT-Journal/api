defmodule StatWeb.Resolvers.Posts do
  alias Stat.Posts

  def list_text_posts(_, _, %{context: %{current_user: user}}) do
    case Posts.list_text_posts(user) do
      {:ok, text_posts} -> {:ok, text_posts}
      {:error, _} -> {:error, "Error fetching text posts"}
    end
  end

  def list_text_posts(_, _, _) do
    {:error, "Please log in first"}
  end

  def create_text_post(_, %{body: body}, %{context: %{current_user: user}}) do
    case Posts.create_text_post(%{body: body}, user) do
      {:ok, text_post} -> {:ok, text_post}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def create_text_post(_, _, _) do
    {:error, "Please log in first"}
  end
end
