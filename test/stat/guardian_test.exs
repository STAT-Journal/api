defmodule Stat.GuardianTest do
  use Stat.DataCase
  alias Stat.Guardian
  import Stat.AccountsFixtures
  alias Stat.Accounts.{User}

  describe "on_revoke/3" do
    test "token is valid before revocation" do
      user = user_fixture()
      Guardian.encode_and_sign(user, %{}, token_type: "access")
      |> case do
        {:ok, token, claims} ->
          assert {:ok, _} = Guardian.decode_and_verify(token)
        {:error, _} ->
          assert false = "Token could not be encoded"
      end
    end

    test "token is invalid after revocation" do
      user = user_fixture()
      Guardian.encode_and_sign(user)
      |> case do
        {:ok, token, claims} ->
          Guardian.revoke(token)
          assert {:error, _} = Guardian.decode_and_verify(token)
        {:error, _} ->
          assert false = "Token could not be encoded"
      end
    end
  end
end
