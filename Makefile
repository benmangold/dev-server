#!/usr/bin/env make

PHONY: all
all: validate build

.PHONY: validate
validate:
	pipenv --python /usr/bin/python3 run packer validate ubuntu/ubuntu-ami.json

.PHONY: build
build:
	pipenv --python /usr/bin/python3 run packer build ubuntu/ubuntu-ami.json
