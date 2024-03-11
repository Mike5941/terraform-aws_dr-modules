data "aws_secretsmanager_secret" "db_secret" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}