# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :users,
  ecto_repos: [Users.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :users, UsersWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: UsersWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Users.PubSub,
  live_view: [signing_salt: "Nr2suYTJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :users, :http, HTTPoison

config :users, Users.Mailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: "us-east-1",
  access_key: System.get_env("AWS_ACCESS_KEY"),
  secret: System.get_env("AWS_SECRET_ACCESS_KEY")

config :users, Oban,
  repo: Users.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, registration: 10]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
