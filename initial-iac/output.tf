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