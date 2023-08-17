FROM elixir:1.14

COPY ./ /app
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new
RUN mix deps.get