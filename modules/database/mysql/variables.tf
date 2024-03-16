data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-wonsoong"
    key    = var.vpc_remote_state_key
    region = "ap-northeast-2"
  }
}

#data "terraform_remote_state" "web" {
#  backend = "s3"
#  config = {
#    bucket = "terraform-wonsoong"
#    key = var.web_remote_state_key
#    region = "ap-northeast-2"
#  }
#}
#
#variable "web_remote_state_key" {
#  value = string
#}

variable "project_name" {
  type    = string
  default = "ha-web"
}

variable "db_name" {
  type    = string
  default = null
}

variable "db_username" {
  type      = string
  sensitive = true
  default   = null
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = null
}

variable "vpc_remote_state_key" {
  type    = string
  default = "stage/network/primary/terraform.tfstate"
}

variable "backup_retention_period" {
  description = "Days to retain backups. Must be > 0 to enable replication."
  type        = number
  default     = null
}

variable "replicate_source_db" {
  description = "If specified, replicate the RDS database at the given ARN."
  type        = string
  default     = null
}

locals {
  seoul_region = "ap-northeast-2"
  mysql_port   = 3306
}
