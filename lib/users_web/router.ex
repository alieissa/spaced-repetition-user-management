defmodule UsersWeb.Router do
  use UsersWeb, :router
  use Plug.ErrorHandler

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

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UsersWeb do
    pipe_through :api

    post "/", UserController, :create
    post "/login", UserController, :login
  end
end
