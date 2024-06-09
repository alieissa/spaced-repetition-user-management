defmodule Users.Tokens do
  def exists!(token) do
    Redix.command!(:tokens, ["EXISTS", token])
  end

  def remove!(token) do
    Redix.command!(:tokens, ["DEL", token])
  end

  def blacklist!(token) do
    # TODO Set expiry time in config
    Redix.command!(:tokens, ["SETEX", token, 7 * 24 * 60 * 60, 0])
  end
end
