# TODO
# 1. Add no route error handler, and test it.
defmodule UsersWeb.UserControllerTest do
  use UsersWeb.ConnCase

  import Mox
  import Users.Factory
  alias Users.Accounts.User

  @invalid_attrs %{password: nil, email: nil, first_name: nil, last_name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "create user when data is valid", %{conn: conn} do
      conn =
        post(conn, ~p"/users/signup", %{
          password: "jbravo01",
          email: "jbravo@test.com"
        })

      assert %{"token" => _token} = json_response(conn, 201)
    end

    test "return errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/users/signup", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:login_user]

    test "update user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/users/#{user}", %{"first_name" => "John", "last_name" => "Charlie"})

      assert %{
               "id" => ^id,
               "first_name" => "John",
               "last_name" => "Charlie"
             } = json_response(conn, 200)
    end

    test "returns errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/users/#{user}", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  @tag :skip
  describe "delete user" do
    setup [:login_user]

    test "archive chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/users/#{user}")
      end
    end

  end
  @tag :skip
  describe "forward" do
    test "request forwarded", %{conn: conn} do
      http = Application.get_env(:users, :http)
      put(conn, ~p"/forwardedurl/", %{"character" => "Johnny Bravo"})
      expect(http, :request, 0, fn _ -> {:ok} end)
    end
  end

  defp login_user(%{conn: conn}) do
    user = insert(:user)

    conn =
      conn
      |> post(~p"/users/login", %{
        "email" => "jbravo@test.com",
        "password" => "jbravo1a"
      })

    %{"token" => token} = json_response(conn, 200)

    conn =
      conn
      |> recycle()
      |> put_req_header("authorization", "Bearer #{token}")
      |> put_req_header("accept", "application/json")

    %{conn: conn, user: user}
  end
end
