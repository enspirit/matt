IMAGE = enspirit/matt
SHELL=/bin/bash -o pipefail
DOCKER_REGISTRY := $(or ${DOCKER_REGISTRY},${DOCKER_REGISTRY},docker.io)

################################################################################
### Config variables
###

# Load them from an optional .env file
-include .env

# Specify which docker tag is to be used
VERSION := $(or ${VERSION},${VERSION},latest)
DOCKER_REGISTRY := $(or ${DOCKER_REGISTRY},${DOCKER_REGISTRY},docker.io)

TINY = ${VERSION}
MINOR = $(shell echo '${TINY}' | cut -f'1-2' -d'.')
MAJOR = $(shell echo '${MINOR}' | cut -f'1' -d'.')

$(info $(TINY) $(MINOR) $(MAJOR))

################################################################################
### Main docker rules
###

clean:
	rm -rf pkg/*
	rm -rf Dockerfile.log Dockerfile.built Dockerfile.pushed

Dockerfile.built: Dockerfile $(shell git ls-files)
	docker build -t $(IMAGE) . | tee Dockerfile.log
	touch Dockerfile.built

image: Dockerfile.built

Dockerfile.version.pushed: Dockerfile.built
	@if [ -z "$(DOCKER_REGISTRY)" ]; then \
		echo "No private registry defined, ignoring. (set DOCKER_REGISTRY or place it in .env file)"; \
		return 1; \
	fi
	docker tag $(IMAGE) $(DOCKER_REGISTRY)/$(IMAGE):$(VERSION)
	docker push $(DOCKER_REGISTRY)/$(IMAGE):$(VERSION) | tee -a Dockerfile.log
	touch Dockerfile.version.pushed

Dockerfile.tags.pushed: Dockerfile.version.pushed
	docker tag $(IMAGE) $(DOCKER_REGISTRY)/$(IMAGE):${MINOR}
	docker push $(DOCKER_REGISTRY)/$(IMAGE):$(MINOR) | tee -a Dockerfile.log
	docker tag $(IMAGE) $(DOCKER_REGISTRY)/$(IMAGE):${MAJOR}
	docker push $(DOCKER_REGISTRY)/$(IMAGE):$(MAJOR) | tee -a Dockerfile.log
	touch Dockerfile.tags.pushed

push-image: Dockerfile.version.pushed
push-tags: Dockerfile.tags.pushed

################################################################################
### Main development rules
###

Gemfile.lock: Gemfile
	bundle install

bundle: Gemfile.lock

test:
	bundle exec rake test

################################################################################
### Gem Management
###

gem: clean
	docker run -t --rm -v ${PWD}/:/app -w /app ruby bash -c "bundle install && bundle exec rake gem"

gem.publish: gem
	docker run -t --rm -v ${PWD}/:/app -w /app -e GEM_HOST_API_KEY=${GEM_HOST_API_KEY} ruby bash -c "gem push `ls -Art pkg/*.gem | tail -n 1`"
