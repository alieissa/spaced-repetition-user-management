defmodule UsersWeb.UserController do
  use UsersWeb, :controller
  import Plug.Conn

  alias UsersWeb.Auth
  alias Users.Accounts
  alias Users.Events

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

    with {:ok, user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, _} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def create(conn, _, user_params) do
    with {:ok, user} <- Accounts.create_user(user_params),
         {:ok, token, _} <- Auth.get_token(user) do
      Events.new_user(%{email: user.email, token: token})

      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def verify(conn, _, _) do
    conn
    |> Guardian.Plug.current_resource()
    |> Accounts.verify_user()

    send_resp(conn, :ok, "Your email has been verified.You can now login.")
  end

  def login(conn, _, %{"email" => email, "password" => raw_password}) do
    with {:ok, user} <- Accounts.get_verified_user(email),
         {:ok, token, _} <- Auth.get_verified_token(raw_password, user) do
      conn
      |> put_status(:ok)
      |> render(:token, token: token)
    end
  end

  def logout(conn, _, _) do
    conn
    |> get_req_header("authorization")
    |> Auth.blacklist_token()

    send_resp(conn, :ok, "Logout")
  end

  def forgot_password(conn, _, body_params) do
    with {:ok, user} <- Accounts.get_user_by_email(body_params["email"]),
         {:ok, token, _} <- Auth.get_token(user) do
      Events.forgot_password(%{email: user.email, token: token})
      send_resp(conn, 200, "")
    else
      _ -> send_resp(conn, 200, "")
    end
  end

  def forward(conn, _, _) do
    http = Application.get_env(:users, :http)

    with app_request <- to_app_request!(conn),
         {:ok, app_response} <- http.request(app_request) do
      conn
      |> resp(app_response.status_code, app_response.body)
      |> send_resp()
    end
  end

  '''
  More than any other piece logic this function makes it very clear that having
  an Elixir service as an API Gateway is not the the best option.
  '''

  defp to_app_request!(%Plug.Conn{params: %{"filename" => %Plug.Upload{}}} = conn) do
    method = String.to_atom(String.downcase(conn.method))
    url = "#{System.get_env("APP_ENDPOINT")}#{conn.request_path}"

    %Plug.Upload{
      path: file_path,
      content_type: file_content_type,
      filename: filename
    } = conn.body_params["filename"]

    form = [
      {:file, file_path, {"form-data", [name: "file", filename: filename]},
       [{"Content-Type", file_content_type}]}
    ]

    %HTTPoison.Request{
      url: url,
      method: method,
      headers: conn.req_headers,
      params: conn.query_params,
      body: {:multipart, form}
    }
  end

  defp to_app_request!(conn) do
    method = String.to_atom(String.downcase(conn.method))
    url = "#{System.get_env("APP_ENDPOINT")}#{conn.request_path}"
    body = Jason.encode!(conn.body_params)

    %HTTPoison.Request{
      url: url,
      method: method,
      headers: conn.req_headers,
      params: conn.query_params,
      body: body
    }
  end
end
