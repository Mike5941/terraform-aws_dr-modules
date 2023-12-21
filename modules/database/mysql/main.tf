resource "aws_db_instance" "example" {
  identifier_prefix    = var.identifier_prefix
  engine               = var.engine_type
  allocated_storage    = var.volume_size
  instance_class       = var.instance_class
  skip_final_snapshot  = var.skip_final_snapshot
  db_name              = var.db_name
  db_subnet_group_name = var.db_subnet_group_name

  username = var.db_username
  password = var.db_password
}

data "aws_vpc" "prod_vpc" {
  filter {
    name   = "tag:Name"
    values = ["prod-sel-vpc"]
  }
}

output "vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}


resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"
  vpc_id      = data.aws_vpc.prod_vpc.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}






