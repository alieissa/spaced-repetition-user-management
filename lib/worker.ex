defmodule Users.Worker do
  use Oban.Worker, queue: :registration

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email, "token" => token}, tags: ["new-user"]}) do
    welcome = Users.Email.welcome(email: email, token: token)
    Users.Mailer.deliver(welcome)
  end

  def perform(%Oban.Job{args: %{"email" => email, "token" => token}, tags: ["forgot-password"]}) do
    forgot_password = Users.Email.forgot_password(email: email, token: token)
    Users.Mailer.deliver(forgot_password)
    :ok
  end

  def new_user(%{email: email, token: token}) do
    %{email: email, token: token}
    |> new(queue: :registration, tags: ["new-user"])
    |> Oban.insert()
  end

  def forgot_password(%{email: email, token: token}) do
    %{email: email, token: token}
    |> new(queue: :registration, tags: ["forgot-password"])
    |> Oban.insert()
  end
end