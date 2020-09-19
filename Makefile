#!/usr/bin/env make

all: validate build init apply

validate:
	packer validate ubuntu/ubuntu-ami.json

build:
	packer build ubuntu/ubuntu-ami.json

init:
	cd terraform; terraform init;

apply:
	cd terraform; terraform apply;

destroy:
	cd terraform; terraform destroy;

connect:
	./scripts/connect-to-instance.sh
