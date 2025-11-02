FROM elixir:1.17-alpine

LABEL maintainer="Andrew (Nature) Okoye <andrewinsoul@gmail.com>"

RUN apk add --no-cache build-base npm nodejs git inotify-tools

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get

COPY . .

EXPOSE 4000

CMD ["sh", "boot.sh"]