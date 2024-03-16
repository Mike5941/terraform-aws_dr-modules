resource "aws_security_group" "web" {
  name = "${var.cluster_name}-wordpress"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "${var.cluster_name}-wordpress"
  }
}

resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "${var.cluster_name}-alb-sg"
  }
}

locals {
  ssh_group_in = {
    wordpress = aws_security_group.web.id,
  }
  http_group_in = {
    wordpress = aws_security_group.web.id,
    alb = aws_security_group.alb.id
  }
  https_group_in = {
    wordpress = aws_security_group.web.id,
    alb = aws_security_group.alb.id
  }
  all_out = {
    wordpress = aws_security_group.web.id,
    alb = aws_security_group.alb.id
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  for_each = local.ssh_group_in
  type              = "ingress"
  from_port = local.ssh_port
  to_port = local.ssh_port
  protocol = "tcp"
  cidr_blocks = local.all_ips
  security_group_id = each.value
}

resource "aws_security_group_rule" "allow_http_wordpress" {
  for_each = local.http_group_in
  type              = "ingress"
  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = "tcp"
  cidr_blocks       = local.all_ips
  security_group_id = each.value
}

resource "aws_security_group_rule" "allow_https_wordpress" {
  for_each = local.https_group_in
  type              = "ingress"
  from_port         = local.https_port
  to_port           = local.https_port
  protocol          = "tcp"
  cidr_blocks       = local.all_ips
  security_group_id = each.value
}

resource "aws_security_group_rule" "egress_all" {
  for_each = local.all_out
  type              = "egress"
  from_port         = local.any_port
  to_port           = local.any_port
  protocol          = local.any_protocol
  cidr_blocks       = local.all_ips
  security_group_id = each.value
}