defmodule Users.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Users.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        password: "some password",
        first_name: "some first_name",
        last_name: "some last_name"
      })
      |> Users.Accounts.create_user()

    user
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        password: "some password",
        first_name: "some first_name",
        last_name: "some last_name",
        email: "some email"
      })
      |> Users.Accounts.create_user()

    user
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        password: "some password",
        email: "some email",
        first_name: "some first_name",
        last_name: "some last_name"
      })
      |> Users.Accounts.create_user()

    user
  end
end
