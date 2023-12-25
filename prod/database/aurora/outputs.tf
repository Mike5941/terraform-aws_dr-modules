output "address" {
  value       = module.primary_db.endpoint
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.primary_db.port
  description = "The port the database is listening on"
}

output "arn" {
  value       = module.primary_db.arn
  description = "The ARN of the database"
}