FROM ruby:2.7.5

WORKDIR /app

ADD Gemfile* ./

RUN apt-get update && apt-get install -y postgresql-client nodejs git imagemagick

RUN bundle install

ADD . .

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "s", "-b", "0.0.0.0"]