defmodule UsersWeb.Plugs.Health do
  import Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{request_path: "/health"} = conn, _opts) do
    conn
    |> send_resp(200, "healthy")
    |> halt()
  end

  def call(conn, _) do
    conn
  end
end
