defmodule Stat.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stat.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Stat.Accounts.create_user()
    user
  end
end
