variable "project_name" {
  description = "The name of the project."
  type        = string
  default = "HA-WEB"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string

}

variable "enable_dns_hostnames" {
  type        = bool
  description = "enable dns hostnames"
  default     = true
}


# public subnet vars
#----------------------------------------
variable "public_subnets" {
  default = {
    "public-subnet-1" = 0
    "public-subnet-2" = 1
  }
}


# private subnet vars
#----------------------------------------
variable "private_subnets" {
  default = {
    "private-subnet-1" = 0
    "private-subnet-2" = 1
  }
}
variable "auto_ipv4" {
  type        = bool
  description = "enable auto-assign ipv4"
  default     = true
}


# databse subnet vars
#---------------------------------------
variable "database_subnets" {
  default = {
    "database-subnet-1" = 0
    "database-subnet-2" = 1
  }
}


# import availability zones
#----------------------------------------
data "aws_availability_zones" "zone" {
  state = "available"
}


# local variables
#----------------------------------------
locals {
  all_ips = "0.0.0.0/0"
  egress_all_ip = ["0.0.0.0/0"]

  public_sn_id_list = [for s in aws_subnet.public_subnets : s.id]
  private_sn_id_list = [for s in aws_subnet.private_subnets : s.id]
  database_sn_id_list = [for s in aws_subnet.database_subnets : s.id]
  azs = [for i, az in data.aws_availability_zones.zone.names : az if i < 2]
}

