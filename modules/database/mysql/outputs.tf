output "address" {
  value       = aws_db_instance.rds_mysql.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.rds_mysql.port
  description = "The port the database is listening on"
}

output "arn" {
  value       = aws_db_instance.rds_mysql.arn
  description = "The ARN of the database"
}

output "name" {
  value       = aws_db_instance.rds_mysql.db_name
  description = "The name of the database"
}

