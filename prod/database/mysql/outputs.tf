output "primary_address" {
  value       = module.primary.address
  description = "Connect to the primary database at this endpoint"
}

output "primary_port" {
  value       = module.primary.port
  description = "The port the primary database is listening on"
}

output "c" {
  value       = module.primary.arn
  description = "The ARN of the primary database"
}

output "replica_address" {
  value       = module.replica.address
  description = "Connect to the replica database at this endpoint"
}

output "replica_port" {
  value       = module.replica.port
  description = "The port the replica database is listening on"
}

output "replica_arn" {
  value       = module.replica.arn
  description = "The ARN of the replica database"
}