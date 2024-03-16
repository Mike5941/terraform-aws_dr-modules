# deploy subnets
#----------------------------------------------------
# public subnets
resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone = local.azs[each.value]

  map_public_ip_on_launch = var.auto_ipv4

  tags = {
    Name = "${var.project_name}-${each.key}"
    Subnet = "Public"

  }
}

# private subnets
resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value + 1)
  availability_zone = local.azs[each.value]

  tags = {
    Name = "${var.project_name}-${each.key}"
    Subnet = "Private"
  }
}

resource "aws_subnet" "database_subnets" {
  for_each = var.database_subnets
  vpc_id = aws_vpc.web_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value + 200)
  availability_zone = local.azs[each.value]

  tags = {
    Name = "${var.project_name}-${each.key}"
    Subnet = "Database"
  }
}