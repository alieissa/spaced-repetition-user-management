defmodule UsersWeb.Plugs.ResetPassword do
  import Plug.Conn

  alias UsersWeb.Auth.ErrorResponse
  alias UsersWeb.Auth

  def init(default), do: default

  def call(%Plug.Conn{request_path: "/reset-password"} = conn, _opts) do
    is_forgotten_password =
      conn
      |> get_req_header("authorization")
      |> Auth.is_forgotten_password?()

    if is_forgotten_password, do: conn, else: raise(ErrorResponse.Unauthorized)
  end

  def call(conn, _opts), do: conn
end
