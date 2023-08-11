FROM elixir:1.14

RUN mix local.hex --force
RUN mix archive.install hex phx_new