FROM ruby:2.5-alpine

RUN apk add --no-cache \
  build-base \
  nodejs \
  npm \
  postgresql-dev \
  sqlite-dev \
  tzdata
RUN gem install \
  foreman \
  mailcatcher

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/
COPY Gemfile.lock /app/
RUN bundle install
COPY . /app
