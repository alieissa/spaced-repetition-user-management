defmodule Users.AccountsTest do
  use Users.DataCase

  alias Users.Accounts
  alias Users.Accounts.User
  import Users.Factory

  describe "users" do
    @invalid_attrs %{email: nil, password: nil}

    test "list_users/0 returns all users" do
      user = insert(:user)
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user(user.id) == user
    end

    test "get_user_by_email/1 returns user with given email" do
      user = insert(:user)
      assert Accounts.get_user_by_email(user.email) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "jb@test.com", password: "testpassword"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "jb@test.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      update_attrs = %{first_name: "John", last_name: "Charlie"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.first_name == "John"
      assert user.last_name == "Charlie"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user(user.id)
    end

    # TODO: Archive users
    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      # Using match? to assert nill
      # See https://hexdocs.pm/ex_unit/1.12.3/ExUnit.Assertions.html#assert/2
      assert match?(nil, Accounts.get_user(user.id))
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
