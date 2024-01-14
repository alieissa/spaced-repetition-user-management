defmodule UsersWeb.Auth.Guardian do
  use Guardian, otp_app: :users

  alias Users.{Accounts, Accounts.User}

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
    case Accounts.get_user!(id) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  def get_token(email) do
    with %User{} = user <- Accounts.get_user_by_email(email),
         {:ok, token, _claims} <-
           encode_and_sign(user, %{"verified" => user.verified}) do
      {:ok, token, user}
    end
  end

  # TODO: The check for verified is probably overkill
  # Make sure it is needed. A user will only be authenticated
  # if the verified field in their token is set to true
  # see the UsersWeb.Auth.Pipeline.Verified
  def authenticate(email, password) do
    case get_token(email) do
      {:ok, token, %{verified: true} = user} ->
        if Bcrypt.verify_pass(password, user.password),
          do: {:ok, token, user},
          else: {:error, :unauthorized}

      _ ->
        {:error, :unauthorized}
    end
  end
end
