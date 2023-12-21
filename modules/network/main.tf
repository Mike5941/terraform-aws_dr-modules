
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
  for_each = var.subnets
  vpc_id   = aws_vpc.web_vpc.id

  dynamic "route" {
    for_each = can(regex("(?i).*(Pub).*", each.key)) ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.web_igw.id
    }
  }

  dynamic "route" {
    for_each = can(regex("(?i).*(Pri).*", each.key)) ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.primary_ngw.id
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
