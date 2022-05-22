#!/bin/sh
if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
  exec /usr/local/bin/aws-lambda-rie _build/prod/rel/covid_pager/bin/covid_pager start $@
else
  exec _build/prod/rel/covid_pager/bin/covid_pager start $@
fi