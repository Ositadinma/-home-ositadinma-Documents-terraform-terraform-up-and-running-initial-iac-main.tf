data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_autoscaling_group" "example" {
  name = aws_autoscaling_group.example.name
}
