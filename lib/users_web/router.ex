defmodule UsersWeb.Router do
  use UsersWeb, :router
  use Plug.ErrorHandler

  alias UsersWeb.UserController
  alias Phoenix.Router.NoRouteError

  def handle_errors(conn, %{reason: %NoRouteError{message: message}}) do
    conn
    |> json(%{errors: message})
    |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn
    |> json(%{errors: message})
    |> halt()
  end


  def handle_errors(conn, _error) do
    conn |> send_resp(500, "Something went wrong. Please try again.")|> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug UsersWeb.Auth.Pipeline
    plug UsersWeb.Plugs.Verify
  end

  get "/health", UserController, :health_check

  scope "/deregister", UsersWeb do
    pipe_through [:api, :auth]
    get "/", UserController, :delete
  end

  scope "/", UsersWeb do
    pipe_through [:api, :auth]
    get "/logout", UserController, :logout
  end

  scope "/", UsersWeb do
    pipe_through [:api]

    post "/signup", UserController, :create
    post "/login", UserController, :login
  end

  # forward "/", Users.Plugins.Forward
  scope "/", UsersWeb do
    pipe_through [:auth]
    forward "/", UserController, :forward
  end
end
