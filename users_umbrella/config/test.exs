import Config

secret_key_base = "2wRqqKhiOKB1G0M07mIpkelRvcRHpy1sfYgXjfd+eGxElpwH5yAmordwQhJkwm/a"

config :users_web, UsersWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4002],
  secret_key_base: secret_key_base,
  server: false

config :users_core, UsersCore.Repo,
  database: System.get_env("DB_NAME", "spaced_repetition_test"),
  username: System.get_env("DB_USERNAME", "postgres"),
  password: System.get_env("DB_PASSWORD", "postgres"),
  hostname: System.get_env("DB_HOSTNAME", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

redis_host = System.get_env("CACHE_HOST", "localhost")

config :users_core, Redix,
  host: redis_host,
  name: :tokens

config :users_core, Oban,
  repo: UsersCore.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, registration: 10],
  testing: :manual

config :users_web, :http, UsersWeb.HTTPClientMock

config :users_web, UsersWeb.Auth,
  issues: "users_app",
  secret_key: secret_key_base

config :users_core, Users.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :info

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
