defmodule UsersLambdaTest do
  use ExUnit.Case
  doctest UsersLambda

  test "greets the world" do
    assert UsersLambda.hello() == :world
  end
end
