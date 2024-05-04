import Config

# Configure your database
config :users, Users.Repo,
  username: System.get_env("POSTGRES_USERNAME", "postgres"),
  password: System.get_env("POSTGRES_PASSWORD", "postgres"),
  hostname: System.get_env("POSTGRES_HOSTNAME", "db"),
  database: System.get_env("POSTGRES_DB", "spaced_repetition"),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

secret_key_base = System.get_env("SECRET_KEY_BASE")
port = String.to_integer(System.get_env("PORT", "4000"))

config :users, UsersWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: port],
  secret_key_base: secret_key_base,
  code_reloader: true,
  debug_errors: true

config :users, UsersWeb.Auth.Guardian,
  issues: "users_app",
  secret_key: secret_key_base

config :users, Oban,
  repo: Users.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, registration: 10]

redis_host = System.get_env("REDIS_HOST", "redis")

config :users, Redix,
  host: redis_host,
  name: :tokens

config :users, Users.Mailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: System.get_env("AWS_REGION", "us-east-1"),
  # TODO Move keys to runtime.exs
  access_key: System.get_env("AWS_SES_ACCESS_KEY"),
  secret: System.get_env("AWS_SES_SECRET_ACCESS_KEY")

# Enable dev routes for dashboard and mailbox
config :users, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
