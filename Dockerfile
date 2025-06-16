FROM ruby:2.7.6

# Dependências do sistema (sqlite3 etc)
RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-dev nodejs

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Entrypoint para setup db
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
