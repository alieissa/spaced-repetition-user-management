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
  ]
  # pubsub_server: Users.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :users, :http, HTTPoison

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
