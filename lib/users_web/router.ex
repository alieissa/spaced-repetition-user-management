defmodule UsersWeb.Router do
  use UsersWeb, :router
  use Plug.ErrorHandler

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug UsersWeb.Auth.Pipeline.Verified
  end

  pipeline :register do
    plug UsersWeb.Auth.Pipeline.Unverified
  end

  scope "/users", UsersWeb do
    pipe_through :register
    get "/verify", UserController, :verify
  end

  scope "/users", UsersWeb do
    pipe_through [:api, :auth]
    put "/:id", UserController, :update
    get "/logout", UserController, :logout
    get "/deregister", UserController, :delete
    post "/reset-password", UserController, :reset_password
  end

  scope "/users", UsersWeb do
    pipe_through :api
    post "/login", UserController, :login
    post "/register", UserController, :create
  end

  scope "/users", UsersWeb do
    pipe_through :api
    post "/forgot-password", UserController, :forgot_password
  end

  scope "/", UsersWeb do
    pipe_through :auth
    forward "/", UserController, :forward
  end
end
