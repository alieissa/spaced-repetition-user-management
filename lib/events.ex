defmodule Users.Events do
  use Oban.Worker, queue: :registration

  alias Users.{Accounts, Accounts.User}
  alias UsersWeb.Auth.Guardian

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email}}) do
    with %User{} = user <- Accounts.get_user_by_email(email),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user, %{"verified" => false, "email" => email}),
         _ <- Users.Email.welcome(user: user, token: token) do
      :ok
    end
  end

  def new_user(%{"email" => _email, "password" => _password} = user_params) do
    user_params
    |> new(queue: :registration)
    |> Oban.insert()
  end
end
