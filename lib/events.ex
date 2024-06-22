defmodule Users.Events do
  use Oban.Worker, queue: :registration

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email, "token" => token}, tags: ["new-user"]}) do
    welcome = Users.Email.welcome(email: email, token: token)
    Users.Mailer.deliver(welcome)
  end

  def new_user(%{email: email, token: token}) do
    %{email: email, token: token}
    |> new(queue: :registration, tags: ["new-user"])
    |> Oban.insert()
  end
end
