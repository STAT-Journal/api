defmodule Stat.AccountsTest do
  use Stat.DataCase

  alias Stat.Accounts

  import Stat.AccountsFixtures
  alias Stat.Accounts.{User}

  describe "get_user_by_email/1" do
    test "does not return the user if the email does not exist" do
      assert {:error, "User not found"} = Accounts.get_user_by_email("unknown@example.com")
    end

    test "returns the user if the email exists" do
      %{id: id} = user = user_fixture()
      assert {:ok, %User{id: ^id}} = Accounts.get_user_by_email(user.email)
    end
  end


  describe "get_user_by_id/1" do
    test "returns error with invalid id" do
      assert {:error, "User not found"} = Accounts.get_user_by_id(-1)
    end

    test "returns the user with the given id" do
      %{id: id} = user = user_fixture()
      assert {:ok, %User{id: ^id}} = Accounts.get_user_by_id(user.id)
    end
  end
end
