FROM elixir:1.13-alpine

WORKDIR /app

RUN mix do local.hex --force, local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get

COPY lib lib
RUN mix release

ENTRYPOINT [ "_build/prod/rel/covid_pager/bin/covid_pager", "start" ]
CMD [ "Elixir.CovidPager:handler" ]