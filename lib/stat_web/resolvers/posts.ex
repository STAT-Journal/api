defmodule StatWeb.Resolvers.Posts do
  alias Stat.Posts

  def list_text_posts(_, _, _) do
    {:ok, %Stat.Posts.Text{body: "test" }}
  end
end
