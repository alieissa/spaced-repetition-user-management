defmodule UsersLambda do
  @moduledoc """
  Documentation for `UsersLambda`.
  """
require Logger
  @doc """
  Hello world.

  ## Examples

      iex> UsersLambda.handle()
      :world

  """
  def handle do
    Logger.info("Lambda handler")
  end
end
