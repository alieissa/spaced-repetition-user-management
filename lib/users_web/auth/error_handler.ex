defmodule UsersWeb.Auth.ErrorHandler do
  import Plug.Conn
  require Logger

  def auth_error(conn, _, _) do
    send_resp(conn, :unauthorized, "")
  end
end