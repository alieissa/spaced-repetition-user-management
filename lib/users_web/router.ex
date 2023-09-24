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

  get "/health", UsersWeb.UserController, :health_check

  scope "/users", UsersWeb do
    pipe_through [:api, :auth]
    put "/:id", UserController, :update
    get "/logout", UserController, :logout
    get "/deregister", UserController, :delete
  end

  scope "/users", UsersWeb do
    pipe_through :api
    post "/login", UserController, :login
    post "/register", UserController, :create
  end

  scope "/", UsersWeb do
    pipe_through :auth
    forward "/", UserController, :forward
  end
end
