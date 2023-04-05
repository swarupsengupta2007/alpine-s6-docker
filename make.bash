#!/bin/bash

TARGETS="linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6"
BASE_VERION=3.16.5
S6VERSION=3.1.4.2

sudo docker buildx build \
				--build-arg BASE_VERSION=${BASE_VERSION}
				--build-arg S6VERSION=${S6VERSION}
				-t swarupsengupta2007/alpine-s6:3.16.0 \
				-t swarupsengupta2007/alpine-s6:latest \
				--platform ${TARGETS} . $1

