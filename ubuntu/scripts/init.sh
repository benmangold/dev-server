#! /bin/bash

sudo apt-get update

sudo apt-get -y upgrade

sudo apt-get install -y python3 python3-apt aptitud redis-server

######################################################

# Install Docker

sudo apt update

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

sudo apt update

apt-cache policy docker-ce

sudo apt install -y docker-ce

sudo systemctl status docker

sudo usermod -aG docker ubuntu

######################################################

# Install PosgreSQL

sudo apt-get install -y wget ca-certificates

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

sudo apt-get update

sudo apt-get install -y postgresql postgresql-contrib

######################################################
