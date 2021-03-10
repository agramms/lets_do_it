FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /lets_do_it

WORKDIR /lets_do_it
COPY Gemfile /lets_do_it/Gemfile
COPY Gemfile.lock /lets_do_it/Gemfile.lock
RUN bundle install
COPY . /lets_do_it

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
