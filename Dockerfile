FROM ruby:2.7.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /personicle-frontend
WORKDIR /personicle-frontend

COPY Gemfile /personicle-frontend/Gemfile
COPY Gemfile.lock /personicle-frontend/Gemfile.lock

RUN bundle install

COPY . /personicle-frontend

CMD ["rails", "server", "-e", "production", "-p", "3000","-b", "0.0.0.0"]