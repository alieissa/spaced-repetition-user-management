defmodule Users.Events do
  use Oban.Worker, queue: :registration

  alias Users.{Accounts, Accounts.User}
  alias UsersWeb.Auth.Guardian

  @impl Oban.Worker
  def perform(%Oban.Job{args: user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user, %{"verified" => false}),
         _ <- Users.Email.welcome(user: user, token: token) do
      IO.inspect(token)
      :ok
    end
  end

  def new_user(%{email: _email, password: _password} = user_params) do
    user_params
    |> new(queue: :registration)
    |> Oban.insert()
  end
end
