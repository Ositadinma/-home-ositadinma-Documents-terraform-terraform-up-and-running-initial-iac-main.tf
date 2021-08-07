terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "/Users/ositadinmae/.aws/credentials"
  profile                 = "serverless-admin"
}

resource "aws_launch_configuration" "example" {
  image_id        = "ami-02b4e72b17337d6c1"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  user_data       = <<-EOF
    # !/bin/bash
    echo "Hello, world" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
  EOF

  # Required when using a launch configuration with an auto scaling group
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }

}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress = [{
    description      = "Allow all HTTP requests"
    from_port        = var.server_port
    to_port          = var.server_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
  }]
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_autoscaling_group" "example" {
  name = aws_autoscaling_group.example.name
}

output "autoscalling_group" {
  description = "Out puts the min and max size of the group"
  value       = <<-EOF
  The autoscalling group min size is: ${data.aws_autoscaling_group.example.min_size}
  The autoscalling group max size is: ${data.aws_autoscaling_group.example.max_size}
  EOF
}

output "availability_zones" {
  value = data.aws_autoscaling_group.example.availability_zones
}

