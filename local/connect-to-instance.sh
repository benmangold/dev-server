#! /bin/bash

##
## Use this script to connect to your instance after applying terraform
##

export PUBLIC_DNS=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=running Name=tag:Name,Values=terraform-asg-example --region=us-east-2 | jq -r .Reservations[].Instances[].PublicDnsName)

ssh -A ubuntu@$PUBLIC_DNS
