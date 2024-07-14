defmodule StatWeb.Resolvers.Users do
  alias Stat.Users

  def create_user(_, args, _) do
    case Users.create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
