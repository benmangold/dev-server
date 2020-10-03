#! /bin/bash

##
## Use this script to connect to your instance after applying terraform
##

export PUBLIC_DNS=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=running Name=tag:Name,Values=$TF_VAR_name_tag --region=$TF_VAR_region | jq -r .Reservations[].Instances[].PublicDnsName)

echo $PUBLIC_DNS
