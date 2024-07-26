defmodule StatWeb.Resolvers.Posts do
  alias Stat.Posts

  def unsafe_check_if_user_can_check_in(_, _, %{context: %{current_user: user}}) do
    Posts.unsafe_check_if_user_can_check_in(user)
  end

  def unsafe_check_if_user_can_check_in(_, _, _) do
    {:error, "Please log in first"}
  end

  def list_text_posts(_, _, %{context: %{current_user: user}}) do
    case Posts.list_text_posts(user) do
      {:ok, text_posts} -> {:ok, text_posts}
      {:error, _} -> {:error, "Error fetching text posts"}
    end
  end

  def list_text_posts(_, _, _) do
    {:error, "Please log in first"}
  end

  def list_moments(_, _, %{context: %{current_user: user}}) do
    case Posts.list_moments(user) do
      {:ok, moments} -> {:ok, moments}
      {:error, _} -> {:error, "Error fetching moments"}
    end
  end

  def list_moments(_, _, _) do
    {:error, "Please log in first"}
  end

  def update_text_post(_, %{id: id, body: body}, %{context: %{current_user: user}}) do
    args = %{id: id, body: body, user_id: user.id}
    case Posts.update_text_post(args) do
      {:ok, text_post} -> {:ok, text_post}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def update_text_post(_, _, _) do
    {:error, "Please log in first"}
  end

  def create_text_post(_, %{body: body}, %{context: %{current_user: user}}) do
    args = %{body: body, user_id: user.id}
    case Posts.create_text_post(args) do
      {:ok, text_post} -> {:ok, text_post}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def create_text_post(_, _, _) do
    {:error, "Please log in first"}
  end

  def create_moment(_, %{type: type}, %{context: %{current_user: user}}) do
    args = %{type: type, user_id: user.id}
    case Posts.create_moment(args) do
      {:ok, moment} -> {:ok, moment}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def create_moment(_, _, _) do
    {:error, "Please log in first"}
  end

  def create_weekly_checkin(_, %{valence: valence}, %{context: %{current_user: user}}) do
    args = %{valence: valence, user_id: user.id}
    case Posts.create_weekly_checkin(args) do
      {:ok, checkin} -> {:ok, checkin}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
