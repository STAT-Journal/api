defmodule Stat.Posts do
  import Ecto.Query, warn: false
  alias Stat.Repo
  import Stat.Queryable
  import Stat.Mutatable

  def list_text_posts(user) do
    Stat.Posts.Text
    |> where_user(user)
    |> where_not_deleted()
  end

  def create_text_post(user, args) do
    Stat.Posts.Text
    |> create_for_user(args, user)
  end

  def list_moments do
    Stat.Posts.Moment
    |> where_not_deleted()
  end

  def list_moments(user) do
    list_moments()
    |> where_user(user)
  end

  def create_moment(user, args) do
    Stat.Posts.Moment
    |> create_for_user(args, user)
  end
end
