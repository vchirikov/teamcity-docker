# TeamCity docker

This repo contains teamcity server and minimal teamcity agent with dotnet sdk 2.1.

## Before start

1. Install [docker](https://docker.com)
2. Open cmd/ps and go to repo root directory
3. Run `docker-compose build`

## Start

1. Run command: `docker-compose up`
1. ...
1. TeamCity server runned on [http://localhost:8111/](http://localhost:8111/)
1. Profit!

After run you can see logs of the running services (or logs both of them).

For gracefully stopping just press `CTRL+C`.
