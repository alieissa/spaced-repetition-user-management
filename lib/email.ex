defmodule Users.Email do
  import Swoosh.Email

  def welcome(user: user, token: token) do
    app_endpoit = System.get_env("APP_ENDPOINT")
    verify_url = "#{app_endpoit}/users/verify?token=#{token}"
    html_body = "Thank you for signing up. Please click <a href=#{verify_url}>here</a> to verify your email"
    new()
    |> to(user.email)
    |> from("info@spaced-reps.com")
    |> subject("spaced-reps.com signup")
    |> html_body(html_body)
    |> text_body("Please verify your email\n")
    |> Users.Mailer.deliver()
  end
end
