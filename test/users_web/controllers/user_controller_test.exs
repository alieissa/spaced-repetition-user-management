defmodule UsersWeb.UserControllerTest do
  use UsersWeb.ConnCase

  import Mox
  import Users.Factory
  alias Users.Accounts.User
  alias UsersWeb.Auth.Guardian

  @invalid_attrs %{email: "invalidemail", first_name: nil, last_name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "verify user" do
    setup [:create_unverified_user_conn]

    test "should verify user when token is valid", %{conn: conn} do
      conn = get(conn, ~p"/users/verify")
      assert "Your email has been verified.You can now login." = response(conn, 200)
    end
  end

  describe "create user" do
    test "create user when data is valid", %{conn: conn} do
      conn =
        post(conn, ~p"/users/register", %{
          password: "jbravo01",
          email: "jbravo@test.com"
        })

      assert _ = response(conn, 201)
    end

    test "return errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/users/register", @invalid_attrs)
      assert _ = response(conn, 422)
    end
  end

  describe "update user" do
    setup [:create_verified_user_conn]

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
    setup [:create_verified_user_conn]

    test "archive chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/users/#{user}")
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, ~p"/users/#{user}")
      end)
    end
  end

  describe "login user" do
    setup [:create_verified_user_conn]

    test "login", %{conn: conn, user: _user} do
      # Email and password are creds of verified user
      conn =
        post(conn, ~p"/users/login", %{"email" => "jbravo@test.com", "password" => "jbravo1a"})

      assert response(conn, 200)
    end
  end

  describe "forward" do
    test "request forwarded", %{conn: conn} do
      http = Application.get_env(:users, :http)
      put(conn, ~p"/forwardedurl/", %{"character" => "Johnny Bravo"})
      expect(http, :request, 0, fn _ -> {:ok} end)
    end
  end

  describe "health" do
    test "check health", %{conn: conn} do
      conn = get(conn, ~p"/health", @invalid_attrs)
      assert "healthy" = response(conn, 200)
    end
  end

  defp create_user_conn(%{conn: conn, user_data: user_params}) do
    user =
      insert(:user,
        verified: user_params.verified,
        email: user_params.email,
        password: user_params.password
      )

    {:ok, token, user} = Guardian.get_token(user.email)

    conn =
      conn
      |> recycle()
      |> put_req_header("authorization", "Bearer #{token}")
      |> put_req_header("accept", "application/json")

    %{conn: conn, user: user}
  end

  defp create_unverified_user_conn(%{conn: conn}) do
    user_data = %{
      email: "jbravo@test.com",
      password: "jbravo1a",
      verified: false
    }

    create_user_conn(%{conn: conn, user_data: user_data})
  end

  defp create_verified_user_conn(%{conn: conn}) do
    user_data = %{
      email: "jbravo@test.com",
      password: "jbravo1a",
      verified: true
    }

    create_user_conn(%{conn: conn, user_data: user_data})
  end
end
