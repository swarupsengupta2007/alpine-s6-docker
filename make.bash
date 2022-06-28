#!/bin/bash

TARGETS="linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6"

sudo docker buildx build -t swarupsengupta2007/alpine-s6:3.16.0 -t swarupsengupta2007/alpine-s6:latest --platform ${TARGETS} . $1

