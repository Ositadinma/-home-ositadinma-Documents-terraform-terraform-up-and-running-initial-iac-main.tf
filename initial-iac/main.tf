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
  shared_credentials_file = "/Users/ositadinmae/.aws/credentials"
  profile = "serverless-admin"
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
  type = number
  default = 8080
}

output "outputt-public_server" {
  description = "Out puts public server ip"
  value = aws_instance.example.public_ip
  
}