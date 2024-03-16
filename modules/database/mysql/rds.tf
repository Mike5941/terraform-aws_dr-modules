resource "aws_db_instance" "rds_mysql" {
  identifier_prefix    = "${var.project_name}-rds"

  allocated_storage    = 10
  instance_class       = "db.t3.medium"
  skip_final_snapshot  = true

  db_subnet_group_name = data.terraform_remote_state.vpc.outputs.db_subnet_group
  backup_retention_period = var.backup_retention_period
  replicate_source_db = var.replicate_source_db
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  engine   = var.replicate_source_db == null ? "mysql" : null
  db_name  = var.replicate_source_db == null ? var.db_name : null
  username = var.replicate_source_db == null ? var.db_username : null
  password = var.replicate_source_db == null ? var.db_password : null
}
