terraform {
    backend "s3" {
        bucket = "benmangold-tf-state-bucket"
        key = "globals/s3/terraform.tfstate"
        region = "us-east-2"

        dynamodb_table = "benmangold-tf-state-lock-table"
        encrypt= "true"
    }
}

variable "server_port" {
    description = "The port used by the server for HTTP requests"
    type = number
    default = 8080
}

variable "name_tag" {
    description = "name applied to resources and tags, sometimes used in utility script queries"
    type = string
}

variable "key_name" {
    description = "AWS key name used for SSH access"
    type = string
}

variable "aws_region" {
    description = "AWS region"
    type = string
}

variable "ami_id" {
    description = "AWS AMI ID used in launch configuration"
    type = string
}

provider "aws" {
    region = var.aws_region
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}

resource "aws_launch_configuration" "example" {
    image_id = var.ami_id
    instance_type = "t2.medium"
    key_name = var.key_name
    security_groups = [aws_security_group.instance.id]
    user_data = <<-EOF
        #!/bin/bash
        echo "Hello World" > index.html
        nohup busybox httpd -f -p 8080 &
        EOF
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_lb" "example" {
    name = var.name_tag
    load_balancer_type = "application"
    subnets = data.aws_subnet_ids.default.ids
    security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.example.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
    }
}

resource "aws_security_group" "alb" {
    name = "terraform-alb"

    ingress {
        from_port  = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "http traffic"
    }

    ingress {
        from_port  = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh traffic"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb_target_group" "asg" {
    name = var.name_tag
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
}

resource "aws_autoscaling_group" "example" {
    launch_configuration = aws_launch_configuration.example.name
    vpc_zone_identifier = data.aws_subnet_ids.default.ids

    target_group_arns = [aws_lb_target_group.asg.arn]
    health_check_type = "ELB"

    min_size = 1
    max_size = 1

    tag {
        key = "Name"
        value = var.name_tag
        propagate_at_launch = true
    }
}

resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.asg.arn
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-instance"
    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description      = "ingress from all ipv4"
    }
    ingress {
        from_port  = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ingress from ssh"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "alb_dns_name" {
    value = aws_lb.example.dns_name
    description = "The domain of the load balancer"
}
