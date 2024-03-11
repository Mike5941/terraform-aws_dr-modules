terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.vpc_remote_state_bucket
    key    = var.vpc_remote_state_key
    region = local.seoul_region
  }
}

resource "aws_db_instance" "rds_mysql" {
  identifier_prefix    = "pilotlight-rds"

  allocated_storage    = 10
  instance_class       = "db.t3.medium"
  skip_final_snapshot  = true

  db_subnet_group_name = "db-subnet-group"
  backup_retention_period = var.backup_retention_period
  replicate_source_db = var.replicate_source_db
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  engine   = var.replicate_source_db == null ? "mysql" : null
  db_name  = var.replicate_source_db == null ? var.db_name : null
  username = var.replicate_source_db == null ? var.db_username : null
  password = var.replicate_source_db == null ? var.db_password : null
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = local.mysql_port
    to_port     = local.mysql_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}