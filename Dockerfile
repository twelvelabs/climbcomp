FROM ruby:2.5.1-alpine

RUN apk add --update \
  bash \
  build-base \
  nodejs \
  postgresql \
  postgresql-dev \
  tzdata \
  yarn \
  && rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

COPY Gemfile* /app/
RUN bundle install --jobs 4

COPY . /app

CMD ["/app/bin/server"]
