FROM ruby:2.7.2
LABEL maintainer="mabiesen@outlook.com"
WORKDIR /repo/
COPY . .
RUN bundle update --bundler
RUN bundle install

CMD ["ruby", "tic_tac_toe.rb"]
