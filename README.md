# dev-server

ephemeral ubuntu development environment in an ami

built with packer and ansible

postgresql, docker, nodejs 12, oh-my-zsh, ready out of the box

launch the ami as an ec2 instance and ssh in as user `ubuntu`

configured via [benmangold/dev-server-role](https://github.com/benmangold/dev-server-role) and Ansible Galaxy

## commands

`make validate` - validate packer json

`make build` - build ami via packer: requires `AWS_ACCESS_KEY_ID`  and `AWS_SECRET_ACCESS_KEY` to be available in environment

## ci

a new ami will build with commits to `main`

## special thanks

to [artis3n/cloud-hackbox](https://github.com/artis3n/cloud-hackbox) for inspiration and reference
