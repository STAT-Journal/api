defmodule StatWeb.Resolvers.Auths do
  alias Stat.Accounts
  alias Stat.Guardian

  def fake_login(_, _) do
    Guardian.encode_and_sign(%{id: 1})
  end

  def login(_, %{email: email, password: password}, _) do
    case fake_login(email, password) do
      {:ok, token, _claims} -> {:ok, %{token: token}}
      {:error, reason} -> {:error, reason}
    end
  end

  def register(_, %{email: email, password: password}, _) do
    case Accounts.create_user(%{email: email, password: password}) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
