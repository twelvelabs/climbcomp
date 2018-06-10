## Overview

tktk

## Prerequisites

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Install

```bash
git clone git@github.com:twelvelabs/climbcomp.git
cd ./climbcomp

docker-compose build
docker-compose run --rm app rake db:setup
```


## Running

```bash
docker-compose up
open http://0.0.0.0:3000
```


## Tests

```bash
docker-compose run --rm app rails test
```

Note: the above runs tests in a new container each time (and thus doesn't take advantage of `spring`). It's much more efficient to start up a persistent shell process if you're repeatedly running tests:

```bash
docker-compose run --rm app bash
# inside the container
rails t path/to/some/test.rb
# code changes
rails t path/to/some/test.rb
# etc...
```
