defmodule Users.Email do
  import Swoosh.Email

  def welcome(email: email, token: token) do
    verification_url = System.get_env("VERIFICATION_URL")
    verification_link = "#{verification_url}?token=#{token}"

    html_body =
      "Thank you for signing up. Please click <a href=#{verification_link}>here</a> to verify your email"

    new()
    |> to(email)
    |> from("info@spaced-reps.com")
    |> subject("spaced-reps.com signup")
    |> html_body(html_body)
    |> text_body("Please verify your email\n")
  end
end
