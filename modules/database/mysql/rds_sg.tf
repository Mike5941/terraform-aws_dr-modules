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


#resource "aws_security_group" "memcached_sg" {
#  name = "${var.cluster_id}-wordpress"
#  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
#
#  tags = {
#    Name = "${var.cluster_id}-wordpress"
#  }
#}
#
#resource "aws_security_group_rule" "allow_ssh" {
#  type              = "ingress"
#  from_port = local.memcached_port
#  to_port = local.memcached_port
#  protocol = "tcp"
#  source_security_group_id = data.terraform_remote_state.web.outputs.web_sg_id
#  security_group_id = aws_security_group.memcached_sg.id
#}
