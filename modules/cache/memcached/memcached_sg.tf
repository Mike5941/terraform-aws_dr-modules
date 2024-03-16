#resource "aws_security_group" "memcached_sg" {
#  name        = "memcached-sg"
#  description = "Memcached Security Group"
#  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
#
#  ingress {
#    from_port   = local.memcached_port
#    to_port     = local.memcached_port
#    protocol    = "tcp"
#    security_groups = [data.terraform_remote_state.web.outputs.web_sg_id]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = local.all_protocols
#    cidr_blocks = local.all_ip
#  }
#
#  tags = {
#    Name = "Memcached SG"
#  }
#}

resource "aws_security_group" "memcached_sg" {
  name = "${var.cluster_id}-wordpress"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "${var.cluster_id}-wordpress"
  }
}

resource "aws_security_group_rule" "allow_web_sg" {
  type              = "ingress"
  from_port = local.memcached_port
  to_port = local.memcached_port
  protocol = "tcp"
  source_security_group_id = data.terraform_remote_state.web.outputs.web_sg_id
  security_group_id = aws_security_group.memcached_sg.id
}
