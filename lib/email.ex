defmodule Users.Email do
  import Swoosh.Email

  def welcome(user: user, token: _token) do
    new()
    |> to(user.email)
    |> from("info@spaced-reps.com")
    |> subject("Spaced Repetition Signup Verification!")
    |> html_body("<h1>Spaced Rep</h1>")
    |> text_body("Please verify your email\n")
    |> Users.Mailer.deliver()
  end
end
