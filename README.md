# Matt - A monitoring tool for data-driven business decisions

Matt is a CTO-oriented tool that helps capturing daily data points that are
relevant for conducting growth hacking and other data-driven decisions.

It consists of the following abstractions:

* Datasource: provides access to data from which measures are extracted
* Measure: standardized data vector for relevant decisions
* Exporter: a way to save measures for future analysis and visualization

## How to install Matt?

There are various usage scenario to use matt, according to your needs and
types of environment and datasources.

### As a commandline

To simply use Matt as a commandline and connect to local databases, simply
install and use the ruby gem:

```
gem install matt
matt --help
```

### As a docker image

If you don't have ruby installed and want to use docker instead, we provide a
docker image that has Matt as entrypoint.

```
docker run enspirit/matt --help
```

Please check docker's network documentation if you want Matt to connect to
databases running on your host.

### In a Gemfile

It may be useful to use Matt as part of a larger ruby gemset, for instance
because you need various ruby gems to connect to mysql, postgres, or whatever.

Then in your Gemfile:

```
source https://rubygems.org

gem "matt"
```

Then,

```
bundle exec matt --help
```

### As a docker base image + a Gemfile

If Matt is part of a larger docker/kubernetes infrastructure, you probably need
the last scenario while also having your own docker image for the component.

This is a good basis for a Dockerfile:

```
FROM enspirit/matt

COPY Gemfile .
RUN bundle install

ENTRYPOINT ['bundle', 'exec', 'matt']
```

Let's say you build that image as `my/matt`, you can now simply run matt as
follows:

```
docker run my/matt --help
```

## Contribute

Please use github issues and pull requests for all questions, bug reports,
and contributions. Don't hesitate to get in touch with us with an early code
spike if you plan to add non trivial features.

## Licence

This software is distributed by Enspirit SRL under a MIT Licence. Please
contact Bernard Lambeau (blambeau@gmail.com) with any question.

Enspirit (https://enspirit.be) and Klaro App (https://klaro.cards) are both
actively using and contributing to the library.
