# CovidPager

Sends Covid metrics to CloudWatch and pages you if they breach a threshold.

## Development

Lambda can be tested locally with Docker using
[RIE](https://docs.aws.amazon.com/lambda/latest/dg/images-test.html):

```
docker build -t covid_pager .
docker run -p 9000:8080 covid_pager:latest

# Query lambda from another terminal
# NOTE: Data payload needs to be double-quote (poison cannot parse single-quote)
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d "{}"
```

## Deploy to AWS

Create `deployment/.env` using sample `deployment/sample.env` and fill in email(s).

Ensure Docker is installed and running.

```
cd deployment
npm i -g aws-cdk
npm install
cdk deploy --all
```

## Acknowledgements

- Data from Johns Hopkins: https://coronavirus.jhu.edu
- Lambda Elixir runtime: https://github.com/aws-samples/aws-lambda-elixir-runtime