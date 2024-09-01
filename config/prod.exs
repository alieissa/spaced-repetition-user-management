import Config

# Do not print debug messages in production
config :logger, level: :debug

config :users, Users.Mailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: System.get_env("REGION"),
  access_key: System.get_env("AWS_SES_ACCESS_KEY"),
  secret: System.get_env("AWS_SES_SECRET_ACCESS_KEY")

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
