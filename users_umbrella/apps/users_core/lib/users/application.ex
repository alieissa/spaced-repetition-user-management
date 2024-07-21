defmodule UsersCore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      UsersCore.Repo,
      # Run migrations
      {Ecto.Migrator, repos: Application.fetch_env!(:users_core, :ecto_repos)},
      # Queue for mail
      {Oban, Application.fetch_env!(:users_core, Oban)},
      # Start Redix worker
      {Redix, Application.fetch_env!(:users_core, Redix)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UsersCore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
