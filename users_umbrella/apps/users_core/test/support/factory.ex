defmodule UsersCore.Factory do
  use ExMachina.Ecto, repo: UsersCore.Repo
  alias UsersCore.Accounts.User

  def user_factory(attrs \\ %{}) do
    email = Map.get(attrs, :email, "jbravo@test.com")
    password = Map.get(attrs, :password, "jbravo1a")
    verified = Map.get(attrs, :verified, false)

    %User{
      email: email,
      password: Bcrypt.hash_pwd_salt(password),
      verified: verified,
      first_name: "Johnny",
      last_name: "Bravo",
    }
  end
end
