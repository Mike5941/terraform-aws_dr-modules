output "db_credentials" {
  description = "Database credentials"
  value       = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)
  sensitive = true
}
