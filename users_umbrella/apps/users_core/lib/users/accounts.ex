defmodule UsersCore.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias UsersCore.Repo

  alias UsersCore.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Return nil if the User does not exist.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      ** nil

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user by email

  Returns error if the user does not exist.

  ## Examples

     iex> get_user_by_email("foo@bar.com")
     {:ok, %User{}}

     iex> get_user_by_email("foo@baz.com")
     {:error, "User not found."}
  """
  def get_user_by_email(email) do
    query = from u in User, where: u.email == ^email

    case Repo.one(query) do
      %User{} = user -> {:ok, user}
      nil -> {:error, "User not found."}
    end
  end

  def get_verified_user(email) do
    query = from u in User, where: u.email == ^email and u.verified == true

    case Repo.one(query) do
      %User{verified: true} = user -> {:ok, user}
      %User{verified: false} -> {:error, "User not verified."}
      nil -> {:error, "User not found."}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Verifies a user.

  ## Examples

      iex> verify_user(user)
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def verify_user(user) do
    user
    |> User.changeset(%{verified: true})
    |> Repo.update()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def validate_user(%{} = attrs) do
    case User.changeset(%User{}, attrs) do
      %Ecto.Changeset{valid?: true, changes: user} -> {:ok, user: user}
      _ -> {:error, :invalid}
    end
  end
end
