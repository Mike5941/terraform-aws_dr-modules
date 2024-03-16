resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = var.cluster_id
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 2
  engine_version       = "1.6.17"
  subnet_group_name    = data.terraform_remote_state.vpc.outputs.cache_subnet_group
  security_group_ids   = [aws_security_group.memcached_sg.id]
}

