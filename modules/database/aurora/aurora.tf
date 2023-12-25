resource "aws_rds_cluster" "primary_cluster"  {
  cluster_identifier = var.cluster_identifier
  engine = var.engine_type
  engine_mode = var.engine_mode
  engine_version = var.engine_version
  database_name = var.db_name
  master_username = var.db_username
  master_password = var.db_password
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  source_region = var.source_region == null? var.source_region : null
  backup_retention_period = var.backup_retention_period == null ? var.backup_retention_period : null
  replication_source_identifier = var.replication_source_identifier == null ? var.replication_source_identifier : null
  skip_final_snapshot = true

  lifecycle {
    ignore_changes = [replication_source_identifier, master_username, master_password]
  }
}

resource "aws_rds_cluster_instance" "primary_instance" {
  count = var.instance_count
  cluster_identifier = aws_rds_cluster.primary_cluster.id
  identifier = "${var.identifier_prefix}-${count.index}"
  instance_class     = var.instance_class
  engine = aws_rds_cluster.primary_cluster.engine
  engine_version = aws_rds_cluster.primary_cluster.engine_version
}

#resource "aws_rds_cluster" "secondary_cluster" {
#  provider = aws.secondary
#
#  cluster_identifier             = "aurora-cluster-secondary"
#  engine                         = var.engine_type
#  replication_source_identifier  = aws_rds_cluster.primary_cluster.arn
#  db_subnet_group_name           = "my-subnet-group-secondary"
#  vpc_security_group_ids         = [aws_security_group[1].aurora_sg.id]
#
#  # 복제본 클러스터에는 마스터 사용자 이름과 암호를 설정하지 않습니다.
#}

resource "aws_security_group" "aurora_sg" {
  name        = "aurora-security-group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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



