resource "aws_db_subnet_group" "rds" {
  depends_on = [aws_subnet.database_subnets]
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.database_subnets["database-subnet-1"].id, aws_subnet.database_subnets["database-subnet-2"].id]

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_elasticache_subnet_group" "elasticache" {
  depends_on = [aws_subnet.database_subnets]
  name       = "cache-subnet-group"
  subnet_ids = [aws_subnet.database_subnets["database-subnet-1"].id, aws_subnet.database_subnets["database-subnet-2"].id]

  tags = {
    Name = "ElastiCache Subnet Group"
  }
}