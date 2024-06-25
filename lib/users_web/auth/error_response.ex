# TODO (44) Remove after error controller has been implemented
defmodule UsersWeb.Auth.ErrorResponse.Unauthorized do
  defexception message: "Unauthorized", plug_status: 401
end
