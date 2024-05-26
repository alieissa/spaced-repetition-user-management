defmodule Users.Events do
  use Oban.Worker, queue: :registration

  alias UsersWeb.Auth.Guardian

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email}}) do
    with {:ok, token, user} <- Guardian.get_token(email) do
      Users.Email.welcome(user: user, token: token)
    end
  end

  def new_user(%{"email" => _email, "password" => _password} = user_params) do
    user_params
    |> new(queue: :registration)
    |> Oban.insert()
  end
end
