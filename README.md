# CovidPager

Sends Covid metrics to CloudWatch and pages you if they breach a threshold.

## Development

TODO

```
mix deps.get
iex -S mix
```

## Deploy to AWS

Ensure Docker is installed and running.

```
cd deployment
npm i -g aws-cdk
cdk deploy
```

## Acknowledgements
- Data from Johns Hopkins: https://coronavirus.jhu.edu
- Lambda Elixir runtime: https://github.com/aws-samples/aws-lambda-elixir-runtime