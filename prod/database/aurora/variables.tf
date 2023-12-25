data "aws_vpc" "primary" {
  provider = aws.primary
  filter {
    name   = "tag:Name"
    values = ["WEB-Primary-vpc"]
  }
}

data "aws_vpc" "secondary" {
  provider = aws.secondary
  filter {
    name   = "tag:Name"
    values = ["WEB-Secondary-vpc"]
  }
}

variable "project_name" {
  type = string
  default = "WEB-Primary"
}

