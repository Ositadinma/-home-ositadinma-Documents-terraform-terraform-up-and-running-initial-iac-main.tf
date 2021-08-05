terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "serverless-admin"
  project = "Terraform-Up-And-Running"
  alias   = "Ireland_data_centre"
}

resource "aws_instance" "example" {
  ami                    = "ami-02b4e72b17337d6c1"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress = [{
    description      = "Allow all HTTP requests"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
  }]
}