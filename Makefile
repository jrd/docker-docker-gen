default: build
build: docker_build output
release: docker_build docker_push output

# Image and binary can be overidden with env vars.
DOCKER_IMAGE ?= jrdasm/docker-gen
CODE_VERSION = $(strip $(shell git describe --always HEAD))
GIT_NOT_CLEAN_CHECK = $(shell git status --porcelain)
ifeq ($(MAKECMDGOALS),release)
ifneq (x$(GIT_NOT_CLEAN_CHECK), x)
$(error echo You are trying to release a build based on a dirty repo)
endif
DOCKER_TAG = $(CODE_VERSION)
else
ifneq (x$(GIT_NOT_CLEAN_CHECK), x)
DOCKER_TAG_SUFFIX = "-dirty"
endif
DOCKER_TAG = $(CODE_VERSION)$(DOCKER_TAG_SUFFIX)
endif

docker_build:
	# Build Docker image
	DOCKER_BUILDKIT=1 docker build \
	  --build-arg VERSION=$(CODE_VERSION) \
	  --build-arg BUILD_DATE=`date -u '+%FT%TZ'` \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

output:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)
