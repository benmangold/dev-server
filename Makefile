#!/usr/bin/env make

##
## terraform and script configuration
##

export TF_VAR_ami_id=ami-0c709a9ae6faff49c

export TF_VAR_aws_region=us-east-2

export TF_VAR_name_tag=dev-server

##
## make commands
##

packer: validate build

validate:
	packer validate ubuntu/ubuntu-ami.json

build:
	packer build ubuntu/ubuntu-ami.json

init:
	cd terraform; terraform init;

apply:
	cd terraform; terraform apply; ../scripts/print-instance-public-dns.sh

# we do not care about key_name when we destroy
# exporting key_name as foo prevents tf promting for it
destroy:
	TF_VAR_key_name=foo cd terraform; terraform destroy;

connect:
	./scripts/connect-to-instance.sh

dns: 
	./scripts/print-instance-public-dns.sh
