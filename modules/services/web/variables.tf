data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

variable "cluster_name" {
  type = string
}

variable "remote_state_bucket" {
  type = string
}

variable "vpc_remote_state_key" {
  type = string
}

variable "db_username" {
  type = string
  sensitive =true
}

variable "db_password" {
  type = string
  sensitive =true
}

variable "db_host" {
  type = string
}

variable "db_port" {
  type = number
}

variable "db_name" {
  type = string
}

locals {
  ssh_port    = 22
  http_port   = 80
  https_port  = 443
  server_port = 8080

  seoul_region = "ap-northeast-2"

  local_cidr    = ["10.0.0.0/8"]
  icmp_protocol = "icmp"
  my_ip         = ["125.242.51.183/32"]
  any_port      = -1
  any_protocol  = "-1"
  all_ips       = ["0.0.0.0/0"]
}