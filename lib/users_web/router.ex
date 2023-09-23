defmodule UsersWeb.Router do
  use UsersWeb, :router
  use Plug.ErrorHandler

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug UsersWeb.Auth.Pipeline
    plug UsersWeb.Plugs.Verify
  end

  get "/health", UsersWeb.UserController, :health_check

  scope "/users/deregister", UsersWeb do
    pipe_through [:api, :auth]
    get "/", UserController, :delete
  end

  scope "/users", UsersWeb do
    pipe_through [:api, :auth]
    put "/:id", UserController, :update
    get "/logout", UserController, :logout
  end

  scope "/users", UsersWeb do
    pipe_through [:api]

    post "/signup", UserController, :create
    post "/login", UserController, :login
  end

  scope "/", UsersWeb do
    pipe_through [:auth]
    forward "/", UserController, :forward
  end
end
