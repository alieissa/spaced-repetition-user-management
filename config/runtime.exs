import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/users start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :users, UsersWeb.Endpoint, server: true
end

config :users, Users.Repo,
  database: System.get_env("DB_NAME", "spaced_repetition"),
  username: System.get_env("DB_USERNAME", "postgres"),
  password: System.get_env("DB_PASSWORD", "postgres"),
  hostname: System.get_env("POSTGRES_HOSTNAME"),
  pool_size: 10

config :users, Oban,
  repo: Users.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, registration: 10]

secret_key_base = System.get_env("SECRET_KEY_BASE")

port = String.to_integer(System.get_env("PORT", "4000"))
config :users, UsersWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: port],
  secret_key_base: secret_key_base

config :users, UsersWeb.Auth.Guardian,
  issues: "users_app",
  secret_key: secret_key_base

redis_host = System.get_env("REDIS_HOST", "redis")
config :users, Redix,
  host: redis_host,
  name: :tokens

if config_env() !== :test do
  config :users, Users.Mailer,
    adapter: Swoosh.Adapters.AmazonSES,
    region: System.get_env("REGION", "us-east-1"),
    access_key: System.get_env("AWS_SES_ACCESS_KEY"),
    secret: System.get_env("AWS_SES_SECRET_ACCESS_KEY")
end
