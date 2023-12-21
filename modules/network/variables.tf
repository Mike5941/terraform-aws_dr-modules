variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "project_name" {
  description = "The name of the project."
  type        = string
}

variable "region_name" {
  type    = string
  default = "sel"
}


variable "subnets" {
  type = map(object({
    cidr                    = string
    az                      = string
    map_public_ip_on_launch = bool
  }))
  default = {}
}

