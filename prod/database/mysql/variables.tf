data "aws_subnet" "selected" {
  for_each = toset(["SN-RDS-Pri-5", "SN-RDS-Pri-6"])

  filter {
    name   = "tag:Name"
    values = [each.value]
  }
}

locals {
  rds_subnet_ids = [for s in data.aws_subnet.selected : s.id]
}
