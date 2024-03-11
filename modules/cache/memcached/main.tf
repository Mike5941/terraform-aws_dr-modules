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
    bucket = var.tf_remote_state_bucket_name
    key    = var.tf_remote_state_key
    region = local.seoul_region
  }
}

resource "aws_elasticache_cluster" "example" {
  count = length(aws_security_group.memcached_sg)
  cluster_id           = var.cluster_id
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 2
  engine_version       = "1.6.17"
  subnet_group_name    = "elasticache-subnet-group"
  security_group_ids   = [aws_security_group.memcached_sg[count.index].id]
}

resource "aws_security_group" "memcached_sg" {
  count = length(data.terraform_remote_state.vpc.outputs)
  name        = "memcached-sg"
  description = "Memcached Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = local.memcached_port
    to_port     = local.memcached_port
    protocol    = "tcp"
    cidr_blocks = local.my_ip
  }

  ingress {
    from_port   = local.memcached_port
    to_port     = local.memcached_port
    protocol    = "tcp"
    cidr_blocks = local.local_ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = local.all_protocols
    cidr_blocks = local.all_ip
  }

  tags = {
    Name = "Memcached SG"
  }
}