defmodule UsersWeb.Auth.Guardian do
  use Guardian, otp_app: :users

  alias Users.Accounts

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user!(id) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  def authenticate(email, password) do
    case Accounts.get_user_by_email(email) do
      nil ->
        {:error, :unauthorized}

      user ->
        if Bcrypt.verify_pass(password, user.password),
          do: encode_and_sign(user),
          else: {:error, :unauthorized}
    end
  end
end
