output "endpoint" {
  value       = aws_rds_cluster_instance.primary_instance[*].endpoint
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_rds_cluster_instance.primary_instance[*].port
  description = "The port the database is listening on"
}

output "arn" {
  value       = aws_rds_cluster.primary_cluster.arn
  description = "The ARN of the database"
}
