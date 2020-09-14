# dev-server

ephemeral ubuntu development environment in an ami

deployed in an aws autoscaling group configured in terraform

built with packer, ansible and terraform

## dev-server-role

postgresql, docker, nodejs 12, oh-my-zsh, ready out of the box

configured via [benmangold/dev-server-role](https://github.com/benmangold/dev-server-role) and Ansible Galaxy

## build scripts

### packer

validate packer json, and then build a new ami with packer (packer calls ansible)

```bash
make validate
make build

```

### terraform

initialize terraform, deploy ami configured in `terraform/main.tf`, and connect with ssh. then, destroy the infrastructure

```bash
make init
make apply
make connect
make destroy

```

## goss

server validation is run by Packer with `Goss`.  Goss validation configs are in `goss.yml`.  

First, Goss is installed via Ansible with [benmangold/install-goss-role](https://github.com/benmangold/install-goss-role) in `ubuntu/ansible/playbook.yml`:

```ansible
    ...
    - name: Goss Install
      import_role:
        name: install-goss-role
    ...
```

then, goss/goss.yml is copied and validated via Packer provisioners in `ubuntu/ubuntu-ami.json`:

```json
    ...
      {
        "type": "file",
        "source": "goss/goss.yml",
        "destination": "/tmp/goss.yml"
      },
      {
        "type": "shell",
        "inline":[
            "goss --gossfile=/tmp/goss.yml validate"
        ]
      },
    ...

```
## terraform

this repo includes configs to deploy the ami to an ec2 in an autoscaling group

note the configs are currently _not_ secure for production use, but allow for http requests to the asg and ssh access to servers

initial terraform configs are ripped out of [benmangold/tf-up-and-running](https://github.com/benmangold/tf-up-and-running)

_do not_ leave this server running until security has been improved

## goss

server validation is run with `goss`.  Goss configs found at `goss/goss.yml`.  Goss is installed via [benmangold/install-goss-role](https://github.com/benmangold/install-goss-role) in `ubuntu/ansible/playbook.yml`:

```ansible
    ...
    - name: Goss Install
      import_role:
        name: install-goss-role
    ...
```

then, goss/goss.yml is copied and validated via Packer provisioners in `ubuntu/ubuntu-ami.json`:

```json
    ...
      {
        "type": "file",
        "source": "goss/goss.yml",
        "destination": "/tmp/goss.yml"
      },
      {
        "type": "shell",
        "inline":[
            "goss --gossfile=/tmp/goss.yml validate"
        ]
      },
    ...

```

## commands

requires `AWS_ACCESS_KEY_ID`  and `AWS_SECRET_ACCESS_KEY` to be available in environment

### packer commands

`make validate` - validate packer json

`make build` - build ami via packer: 

### terraform commands

`make init` - initialize terraform

`make deploy` - deploys ami via `terraform apply`

`make destroy` - destroys current infrastructure

### misc commands

`make connect` - connects to a running, tagged ec2 via ssh

## ci

a new ami will build with commits to `main`

## misc ssh notes

wsl setup

```bash
exec ssh-agent zsh # start ssh-agent if not started
ssh-add # add local ssh keys key
ssh-add ~/.ssh/my-ssh-key.pem # add ec2-auth key
```

be sure to forward your local ssh keys with `-A`

```bash
ssh -A ubuntu@ec2-000-00-00-000.compute-1.amazonaws.com

```

## special thanks

to [artis3n/cloud-hackbox](https://github.com/artis3n/cloud-hackbox) for inspiration and reference
