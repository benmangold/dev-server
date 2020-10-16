#!/usr/bin/env make

##
## make commands - packer
##

packer: validate build

validate:
	packer validate ubuntu/ubuntu-ami.json

build:
	packer build ubuntu/ubuntu-ami.json

##
## terraform and scripts configuration
##

export TF_VAR_ami_id=ami-0a19861ae0360586d

export TF_VAR_aws_region=us-east-2

export TF_VAR_name_tag=dev-server

##
## make commands - terraform and scripts
##

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
