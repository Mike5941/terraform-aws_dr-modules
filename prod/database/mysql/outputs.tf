output "address" {
  value       = module.prod_db.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.prod_db.port
  description = "The port the database is listening on"
}
