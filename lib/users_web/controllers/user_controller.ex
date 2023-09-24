defmodule UsersWeb.UserController do
  use UsersWeb, :controller
  import Plug.Conn

  alias UsersWeb.Auth.{Guardian, ErrorResponse}
  alias Users.{Accounts, Accounts.User, Tokens}

  action_fallback UsersWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.path_params, conn.body_params]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, :show, user: user)
  end

  def update(conn, _, user_params) do
    user = Guardian.Plug.current_resource(conn)
    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def create(conn, _, user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user, %{"verified" => false}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/#{user}")
      |> render(:token, token: token)
    end
  end

  def login(conn, _, %{"email" => email, "password" => raw_password}) do
    case Guardian.authenticate(email, raw_password) do
      {:ok, token, _claims} ->
        conn
        |> put_status(:ok)
        |> render(:token, token: token)

      {:error, :unauthorized} ->
        raise ErrorResponse.Unauthorized
    end
  end

  def logout(conn, _) do
    conn
    |> get_req_header("authorization")
    |> Tokens.blacklist!()

    send_resp(conn, :ok, "Logout")
  end

  def forward(conn, _) do
    http = Application.get_env(:users, :http)

    with app_request <- to_app_request!(conn),
         {:ok, app_response} <- http.request(app_request) do
      conn
      |> resp(app_response.status_code, app_response.body)
      |> send_resp()
    end
  end

  def health_check(conn, _) do
    send_resp(conn, :ok, "healthy")
  end

  defp to_app_request!(conn) do
    path = conn.request_path
    method = String.to_atom(String.downcase(conn.method))
    headers = conn.req_headers
    params = conn.query_params
    body = Jason.encode!(conn.body_params)
    url = "#{System.get_env("APP_ENDPOINT")}#{path}"

    %HTTPoison.Request{
      url: url,
      method: method,
      headers: headers,
      params: params,
      body: body
    }
  end
end
