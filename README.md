# ubuntu-dev

an ubuntu development environment built into an ami with packer and ansible

postgresql, docker, nodejs, oh-my-zsh, ready out of the box for the `ubuntu` user

## commands

`make verify` - verify packer json

`make build` - build ami via packer: requires `AWS_ACCESS_KEY_ID`  and `AWS_SECRET_ACCESS_KEY` to be available in environment
