defmodule Stat.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Stat.DataCase, async: true`, although
  this option is not recommended for other databases.
  """
alias Hex.Netrc.Cache

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Stat.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Stat.DataCase
    end
  end

  setup tags do
    Stat.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    cachex_opts = Application.get_env(:stat, Stat.GuardianCachex)

    processes = [
      { Ecto.Adapters.SQL.Sandbox.start_owner!(Stat.Repo, shared: not tags[:async]),
        &Ecto.Adapters.SQL.Sandbox.stop_owner/1 },
      { Cachex.start_link(cachex_opts),
        fn _pid -> nil end },
    ]

    on_exit(fn ->
      processes
      |> Enum.map(fn {pid, stop} -> stop.(pid) end)
    end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
