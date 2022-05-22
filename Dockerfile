FROM elixir:1.13-alpine

WORKDIR /app

RUN mix do local.hex --force, local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get

COPY lib lib
RUN mix release

ADD aws-lambda-rie-x86_64 /usr/local/bin/aws-lambda-rie
COPY ./entry_script.sh /entry_script.sh

ENTRYPOINT [ "/entry_script.sh" ]
CMD [ "Elixir.CovidPager:handler" ]