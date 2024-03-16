# Edit default route table for public subnets
#----------------------------------------------------
# Public rt
resource "aws_default_route_table" "public_rt" {
  default_route_table_id = aws_vpc.web_vpc.default_route_table_id

  route {
    cidr_block = local.all_ips
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Public rt assoc.
resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_default_route_table.public_rt.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}


# Private Route Table
#----------------------------------------------------
# Private rt
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.web_vpc.id
  depends_on = [aws_nat_gateway.nat_gw]
  for_each = var.private_subnets

  route {
    cidr_block     = local.all_ips
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}

# Private rt assoc.
resource "aws_route_table_association" "private" {
  depends_on     = [aws_subnet.private_subnets]
  for_each = var.private_subnets
  route_table_id = aws_route_table.private_rt[each.key].id
  subnet_id      = aws_subnet.private_subnets[each.key].id
}

# Database Route Table
#----------------------------------------------------
# Database rt
resource "aws_route_table" "database_rt" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    Name = "${var.project_name}-database-rt"
  }
}

# Private rt assoc.
resource "aws_route_table_association" "database" {
  depends_on     = [aws_subnet.database_subnets]
  for_each = aws_subnet.database_subnets
  route_table_id = aws_route_table.database_rt.id
  subnet_id      = aws_subnet.database_subnets[each.key].id
}