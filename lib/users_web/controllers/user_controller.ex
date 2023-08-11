defmodule UsersWeb.UserController do
  use UsersWeb, :controller

  alias UsersWeb.Auth.{Guardian, ErrorResponse}
  alias Users.Accounts
  alias Users.Accounts.User

  action_fallback UsersWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/#{user}")
      |> render(:token, token: token)
    end
  end

  def login(conn, %{"email" => email, "password" => raw_password}) do
    case Guardian.authenticate(email, raw_password) do
      {:ok, token, _claims} ->
        conn
        |> put_status(:ok)
        |> render(:token, token: token)
      {:error, :unauthorized} -> raise ErrorResponse.Unauthorized
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
