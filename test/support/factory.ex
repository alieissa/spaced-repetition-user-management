defmodule Users.Factory do
  use ExMachina.Ecto, repo: Users.Repo
  alias Users.Accounts.User

  def user_factory do
    %User{
      email: "jbravo@test.com",
      password: Bcrypt.hash_pwd_salt("jbravo1a"),
      first_name: "Johnny",
      last_name: "Bravo"
    }
  end
end
