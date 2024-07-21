defmodule UsersWeb.Plugs.Forward do
  def init(default), do: default

  def call(conn, _) do
    conn
  end
end
