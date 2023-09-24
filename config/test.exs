import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
secret_key_base = "2wRqqKhiOKB1G0M07mIpkelRvcRHpy1sfYgXjfd+eGxElpwH5yAmordwQhJkwm/a"

config :users, Users.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  port: 5432,
  database: "users_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :users, UsersWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4002],
  secret_key_base: secret_key_base,
  server: false

config :users, UsersWeb.Auth.Guardian,
  issues: "users_app",
  secret_key: secret_key_base

config :users, Redix,
  host: System.get_env("REDIS_HOST", "localhost"),
  name: :tokens

config :users, Oban, testing: :inline
# config :users, :http,
#   Users.HTTPClientMock

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
