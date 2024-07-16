defmodule UsersWeb.Auth.ErrorHandler do
  import Plug.Conn

  def auth_error(conn, _, _) do
    # TODO(44) Remove this after error controller created
    send_resp(conn, :unauthorized, "")
  end
end
