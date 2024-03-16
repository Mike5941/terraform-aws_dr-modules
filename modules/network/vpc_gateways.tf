# Create Internet Gateway
#----------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.web_vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}


# Create elastic IP
#----------------------------------------------------
resource "aws_eip" "eip" {
  tags = {
    Name = "${var.project_name}-eip"
  }
}


# Create NAT Gateway
#----------------------------------------------------
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnets["public-subnet-1"].id

  tags = {
    Name = "${var.project_name}-nat"
  }
}