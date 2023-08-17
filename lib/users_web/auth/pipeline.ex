defmodule UsersWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :users,
    module: UsersWeb.Auth.Guardian,
    error_handler: UsersWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
end
