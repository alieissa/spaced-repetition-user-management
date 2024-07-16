defmodule UsersCore.Repo do
  use Ecto.Repo,
    otp_app: :users_core,
    adapter: Ecto.Adapters.Postgres
end
