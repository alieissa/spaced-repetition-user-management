defmodule UsersWeb.Plugs.Verify do
  import Plug.Conn

  alias UsersWeb.Auth.ErrorResponse
  alias Users.Tokens

  def init(default), do: default

  def call(conn, _) do
    cached_tokens =
      conn
      |> get_req_header("authorization")
      |> Tokens.exists!()

    if cached_tokens == 0, do: conn, else: raise(ErrorResponse.Unauthorized)
  end
end
