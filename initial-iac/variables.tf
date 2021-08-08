variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "alb_port" {
  description = "The port the ALB will use for HTTP requests"
  type        = number
  default     = 80
}

variable "cidr_blocks_allow_all_traffic" {
  description = "Allows all HTTP traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tcp_protocol" {
  description = "Defines TCP as the chosen protocol"
  type        = string
  default     = "tcp"
}