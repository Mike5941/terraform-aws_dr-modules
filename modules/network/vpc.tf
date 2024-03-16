resource "aws_vpc" "web_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    "Name" = "${var.project_name}-vpc"
  }
}