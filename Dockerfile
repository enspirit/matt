FROM ruby:3.0.1-alpine3.13 as builder

WORKDIR /matt

RUN apk update \
 && apk add --no-cache build-base sqlite sqlite-dev sqlite-libs

COPY matt.gemspec Gemfile ./
COPY lib/matt/version.rb lib/matt/version.rb
RUN bundle install --full-index
RUN apk del --purge build-base sqlite-dev

COPY . .
RUN bundle exec rake test && \
    bundle exec rake gem

##

FROM ruby:3.0.1-alpine3.13

WORKDIR /home/matt

COPY --from=builder /matt /matt

RUN gem install /matt/pkg/matt*.gem

ENTRYPOINT ["matt"]
