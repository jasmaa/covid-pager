# CovidPager

Sends Covid metrics to CloudWatch and pages you if they breach a threshold.

## Development

```
mix deps.get
iex -S mix
```

## Deploy

WIP

```
docker build -t covid_pager .

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ECR repo>

docker tag covid_pager:latest <ECR repo>:latest
docker push <ECR repo>:latest
```

## Acknowledgements
- Data from Johns Hopkins: https://coronavirus.jhu.edu