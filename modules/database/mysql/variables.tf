variable "project_name" {
  type = string
  default = "WEB-Primary"
}

variable "identifier_prefix" {
  type    = string

}

variable "engine_type" {
  type    = string
  default = "mysql"
}

variable "volume_size" {
  type    = number
  default = 10
}

variable "instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string

}

variable "db_password" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

data "aws_vpc" "primary" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-vpc"]
  }
}
