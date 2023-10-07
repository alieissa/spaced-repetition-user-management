import Config

config :users, Users.Repo,
  pool: Ecto.Adapters.SQL.Sandbox

config :users, Oban, testing: :inline

config :users, :http,
  Users.HTTPClientMock

config :users, Users.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
