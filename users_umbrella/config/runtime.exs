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
  config :users_web, UsersWeb.Endpoint, server: true
end

if config_env() == :prod || config_env() == :dev do
  config :users_core,
         :reset_password_url,
         System.get_env("RESET_PASSWORD_URL") ||
           raise("The environment variable RESET_PASSWORD_URL is not set.")

  secret_key_base = System.get_env("SECRET_KEY_BASE")

  config :users_web, UsersWeb.Endpoint,
    http: [ip: {0, 0, 0, 0}, port: String.to_integer(System.get_env("PORT", "4000"))],
    secret_key_base: secret_key_base


    config :users_web, UsersWeb.Auth,
      issues: "users_app",
      secret_key: secret_key_base

  config :users_core, UsersCore.Repo,
    hostname:
      System.get_env("DB_HOSTNAME") || raise("Environment variable DB_HOSTNAME is not set."),
    database: System.get_env("DB_NAME") || raise("Environment variable DB_NAME is not set."),
    username:
      System.get_env("DB_USERNAME") || raise("Environment variable DB_USERNAME is not set."),
    password:
      System.get_env("DB_PASSWORD") || raise("Environment variable DB_PASSWORD is not set."),
    pool_size: 10

  config :users_core, Redix,
    host: System.get_env("CACHE_HOST") || raise("Environment variable CACHE_HOST is not set."),
    name: :tokens

  config :users_core, Oban,
    repo: UsersCore.Repo,
    plugins: [Oban.Plugins.Pruner],
    queues: [default: 10, registration: 10]

  config :users_core, UsersCore.Mailer,
    adapter: Swoosh.Adapters.AmazonSES,
    region: System.get_env("REGION"),
    access_key: System.get_env("AWS_SES_ACCESS_KEY"),
    secret: System.get_env("AWS_SES_SECRET_ACCESS_KEY")
end
