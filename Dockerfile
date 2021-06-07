FROM ruby:3.0.1-alpine3.13 as builder

WORKDIR /matt
COPY matt.gemspec Gemfile ./
COPY lib/matt/version.rb lib/matt/version.rb
RUN bundle install

COPY . .
RUN bundle exec rake test && \
    bundle exec rake gem

FROM ruby:3.0.1-alpine3.13

WORKDIR /matt
COPY --from=builder /matt/pkg/* ./pkg/
RUN gem install pkg/matt*.gem

ENTRYPOINT ["matt"]
