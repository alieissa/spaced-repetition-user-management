defmodule Users.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      UsersWeb.Telemetry,
      # Start the Ecto repository
      Users.Repo,
      # Start Redex worker
      {Redix, host: "redis", name: :tokens},
      # Start the PubSub system
      {Phoenix.PubSub, name: Users.PubSub},
      # Start the Endpoint (http/https)
      UsersWeb.Endpoint
      # Start a worker by calling: Users.Worker.start_link(arg)
      # {Users.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Users.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UsersWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
