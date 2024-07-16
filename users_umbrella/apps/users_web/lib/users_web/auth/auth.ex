defmodule UsersWeb.Auth do
  use Guardian, otp_app: :users_web

  alias UsersCore.Accounts

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  # The entire user is fetched.The entire user entity is
  # needed for updates. Once update_all is used, only the
  # the primary key, i.e. id will be needed
  # See https://hexdocs.pm/ecto/Ecto.Repo.html#c:update_all/3
  # See https://elixirforum.com/t/ecto-why-repo-get-before-repo-update/12043/2
  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  def get_token(user), do: encode_and_sign(user, %{"verified" => user.verified})

  def get_verified_token(password, user) do
    if Bcrypt.verify_pass(password, user.password),
      do: get_token(user),
      else: {:error, "Invalid password"}
  end

  def blacklist_token(token) do
    UsersWeb.Auth.Tokens.blacklist!(token)
  end

  def save_forgotten_token(token) do
    UsersWeb.Auth.Tokens.set(token)
  end

  def forgotten_password?(token) do
    cached_tokens = UsersWeb.Auth.Tokens.exists!(token)
    cached_tokens != 0
  end
end
