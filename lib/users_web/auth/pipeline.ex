defmodule UsersWeb.Auth.Pipeline.Verified do
  use Guardian.Plug.Pipeline,
    otp_app: :users,
    module: UsersWeb.Auth,
    error_handler: UsersWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated, claims: %{verified: true}
  plug Guardian.Plug.LoadResource
  plug UsersWeb.Plugs.Verify
end

defmodule UsersWeb.Auth.Pipeline.Unverified do
  use Guardian.Plug.Pipeline,
    otp_app: :users,
    module: UsersWeb.Auth,
    error_handler: UsersWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated, claims: %{verified: false}
  plug Guardian.Plug.LoadResource
end
