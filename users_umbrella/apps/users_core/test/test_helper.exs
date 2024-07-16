ExUnit.start(exclude: [:skip])
Ecto.Adapters.SQL.Sandbox.mode(UsersCore.Repo, :manual)
Application.ensure_all_started(:logger)
