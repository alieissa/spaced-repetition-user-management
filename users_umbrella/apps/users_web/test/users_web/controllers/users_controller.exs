defmodule UsersWeb.UserControllerTest do
  use UsersWeb.ConnCase
  use Oban.Testing, repo: UsersCore.Repo

  import Mox
  import UsersCore.Factory
  alias UsersWeb.Auth

  @invalid_attrs %{email: "invalidemail", first_name: nil, last_name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "POST /users" do
    test "when input data is valid", %{conn: conn} do
      valid_data = %{
        password: "jbravo01",
        email: "jbravo@test.com"
      }

      conn = post_user(conn, valid_data)

      assert _ = response(conn, 201)
    end

    test "when input data is invalid", %{conn: conn} do
      invalid_data = %{email: "invalidemail"}
      conn = post_user(conn, invalid_data)

      assert response(conn, 422)
    end
  end

  describe "PUT /users/:id" do
    test "when input data is valid", %{conn: conn} do
      %{id: id} = user = setup_user(%{verified: true})
      conn = setup_conn(conn, user)

      valid_data = %{"first_name" => "John", "last_name" => "Charlie"}
      conn = put_user(conn, id, valid_data)

      assert %{
               "id" => ^id,
               "first_name" => "John",
               "last_name" => "Charlie"
             } = json_response(conn, 200)
    end

    test "when input data is invalid", %{conn: conn} do
      user = setup_user(%{verified: true})
      conn = setup_conn(conn, user)

      invalid_data = %{email: "invalidemail"}
      conn = put_user(conn, user.id, invalid_data)

      assert response(conn, 422)
    end
  end

  @tag :skip
  describe "delete user" do
    test "archive chosen user", %{conn: conn} do
      user = setup_user(%{verified: true})
      conn = setup_conn(conn, user)

      conn = delete_user(conn, user.id)
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, ~p"/users/#{user}")
      end)
    end
  end

  test "GET /users/verify", %{conn: conn} do
    user = setup_user(%{verified: false})
    conn = setup_conn(conn, user)

    conn = verify_user(conn)

    assert response(conn, 200)
  end

  test "POST /users/login", %{conn: conn} do
    user_data = %{
      email: "jbravo@test.com",
      password: "jbravo1a",
      verified: true
    }

    user = setup_user(user_data)
    conn = setup_conn(conn, user)

    conn = login(conn, %{email: user_data.email, password: user_data.password})

    resp = json_response(conn, 200)
    assert resp["token"]
  end

  test "GET /users/logout", %{conn: conn} do
    user_data = %{
      email: "jbravo@test.com",
      password: "jbravo1a",
      verified: true
    }

    user = setup_user(user_data)
    conn = setup_conn(conn, user)

    conn = get(conn, ~p"/users/logout")

    assert response(conn, 200)
  end

  describe "POST /users/forgot-password" do
    test "when user is registered and verified", %{conn: conn} do
      user = setup_user()
      conn = setup_conn(conn, user)

      conn = forgot_password(conn, user.email)

      assert response(conn, 200)

      assert_enqueued(
        worker: Users.Worker,
        args: %{"email" => user.email},
        tags: ["forgot-password"]
      )
    end

    test "when user is not registered", %{conn: conn} do
      conn = forgot_password(conn, "does-not-exist@test.com")

      assert response(conn, 200)

      refute_enqueued(
        worker: Users.Worker,
        tags: ["forgot-password"]
      )
    end
  end

  describe "POST /users/reset-password" do
    test "when user is verified", %{conn: conn} do
      user_data = %{password: "johnny1"}
      user = setup_user()
      conn = setup_conn(conn, user)

      new_password = "newpassword"
      conn = reset_password(conn, new_password)
      assert response(conn, 200)

      conn = login(conn, %{email: user.email, password: user_data.password})
      assert response(conn, 401)

      conn = login(conn, %{email: user.email, password: new_password})
      resp = json_response(conn, 200)
      assert resp["token"]
    end

    test "when user is not verified", %{conn: conn} do
      user_data = %{verified: false}
      user = setup_user(user_data)
      conn = setup_conn(conn, user)

      conn = reset_password(conn, "newpassword")

      assert response(conn, 401)
    end
  end

  test "GET /health", %{conn: conn} do
    conn = get(conn, ~p"/health", @invalid_attrs)
    assert "healthy" = response(conn, 200)
  end

  test "request forwarded", %{conn: conn} do
    http = Application.get_env(:users, :http)
    put(conn, ~p"/forwardedurl/", %{"character" => "Johnny Bravo"})
    expect(http, :request, 0, fn _ -> {:ok} end)
  end

  def post_user(conn, data) do
    post(conn, ~p"/users/register", data)
  end

  def put_user(conn, id, data) do
    put(conn, ~p"/users/#{id}", data)
  end

  def verify_user(conn) do
    get(conn, ~p"/users/verify")
  end

  def delete_user(conn, id) do
    delete(conn, ~p"/users/#{id}")
  end

  defp forgot_password(conn, email) do
    post(conn, ~p"/users/forgot-password", %{email: email})
  end

  defp reset_password(conn, password) do
    post(conn, ~p"/users/reset-password", %{password: password})
  end

  defp login(conn, creds) do
    post(conn, ~p"/users/login", creds)
  end

  def setup_user(user_params \\ %{}) do
    user_data =
      Map.merge(
        %{email: "jbravo@test.com", password: "jbravo1a", verified: true},
        user_params
      )

    insert(:user, user_data)
  end

  def setup_conn(conn, user) do
    {:ok, token, _} = Auth.get_token(user)

    conn
    |> recycle()
    |> put_req_header("authorization", "Bearer #{token}")
    |> put_req_header("accept", "application/json")
  end
end
