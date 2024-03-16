output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.web_vpc.id
}

output "public_subnets" {
  description = "Public Subnet ID"
  value = local.public_sn_id_list
}

output "private_subnets" {
  description = "Private Subnet ID"
  value = local.private_sn_id_list
}

output "database_subnets" {
  description = "Database Subnet ID"
  value = local.database_sn_id_list
}

output "azs"{
  value = local.azs
}

output "db_subnet_groups" {
  description = "RDS Subnet Group Name"
  value = aws_db_subnet_group.rds.name
}

output "cache_subnet_groups" {
  description = "Cache Subnet Group Name"
  value = aws_elasticache_subnet_group.elasticache.name
}



