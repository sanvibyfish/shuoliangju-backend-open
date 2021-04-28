FROM ruby:2.6.5

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential nodejs yarn cron

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN gem install bundler:2.1.2
ADD Gemfile Gemfile.lock yarn.lock $APP_HOME/

ADD vendor/cache vendor/cache
RUN bundle install

ADD . $APP_HOME
RUN yarn install --check-files

RUN bundle exec rails assets:precompile