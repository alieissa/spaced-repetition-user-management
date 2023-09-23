ExUnit.start(exclude: [:skip])
Ecto.Adapters.SQL.Sandbox.mode(Users.Repo, :manual)
Mox.defmock(Users.HTTPClientMock, for: HTTPoison.Base)
Application.put_env(:users, :http, Users.HTTPClientMock)
