resource "aws_vpc" "web_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "primary" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = {
    Name = "SN-${each.key}"
  }
}

resource "aws_route_table" "web_rt" {
  for_each = aws_subnet.primary
  vpc_id   = aws_vpc.web_vpc.id

  dynamic "route" {
    for_each = local.is_pub_subnet[each.key] ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.web_igw.id
    }
  }

  dynamic "route" {
    for_each = local.is_web3_subnet[each.key] ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.primary_ngw[0].id
    }
  }

  dynamic "route" {
    for_each = local.is_web4_subnet[each.key] ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.primary_ngw[1].id
    }
  }

  tags = {
    Name = "RT-${each.key}"
  }
}

resource "aws_route_table_association" "sn_rt" {
  for_each       = aws_subnet.primary
  subnet_id      = aws_subnet.primary[each.key].id
  route_table_id = aws_route_table.web_rt[each.key].id
}


resource "aws_eip" "primary_eip" {
  count = 2

  tags = {
    Name = "${var.project_name}-eip${count.index + 1}"
  }
}


resource "aws_nat_gateway" "primary_ngw" {
  count         = 2
  allocation_id = aws_eip.primary_eip[count.index].id
  subnet_id     = aws_subnet.primary["Pub-${count.index + 1}"].id

  tags = {
    Name = "${var.project_name}-ngw${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = local.db_subnet_ids

  tags = {
    Name = "DB Subnet Group"
  }
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name       = "elasticache-subnet-group"
  subnet_ids = local.db_subnet_ids

  tags = {
    Name = "Elasticache Subnet Group"
  }
}


locals {
  is_pub_subnet = { for k, _ in aws_subnet.primary : k => can(regex("(?i).*Pub.*", k)) }
  is_web3_subnet = { for k, _ in aws_subnet.primary : k => can(regex("(?i).*Web-3.*", k)) }
  is_web4_subnet = { for k, _ in aws_subnet.primary : k => can(regex("(?i).*Web-4.*", k)) }
  is_db_subnet = { for k, _ in aws_subnet.primary : k => can(regex("(?i).*DB.*", k)) }

  public_subnet_ids = toset([for k, v in aws_subnet.primary : v.id if can(regex("(?i).*Pub.*", k))])
  web_subnet_ids =  toset([for k, v in aws_subnet.primary : v.id if can(regex("(?i).*Web.*", k))])
  db_subnet_ids = toset([for k, v in aws_subnet.primary : v.id if can(regex("(?i).*DB.*", k))])
}








