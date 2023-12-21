#resource "aws_security_group" "bastions_sg" {
#  name   = "${var.cluster_name}-bastion"
#  vpc_id = local.vpc_id
#
#  tags = {
#    Name = "${var.cluster_name}-bastions_sg"
#
#  }
#}
#
#resource "aws_security_group" "web_sg" {
#  name   = "${var.cluster_name}-web"
#  vpc_id = local.vpc_id
#
#  tags = {
#    Name = "${var.cluster_name}-web_sg"
#
#  }
#}
#
#
#resource "aws_security_group_rule" "allow_ssh_inbound" {
#  type = "ingress"
#
#  security_group_id = aws_security_group.bastions_sg.id
#
#  from_port = local.ssh_port
#  to_port   = local.ssh_port
#  protocol  = "tcp"
#
#  cidr_blocks = local.my_ip
#}
#
#resource "aws_security_group_rule" "allow_ssh_inbound2" {
#  type = "ingress"
#
#  from_port = local.ssh_port
#  to_port   = local.ssh_port
#  protocol  = "tcp"
#
#
#  security_group_id        = aws_security_group.web_sg.id
#  source_security_group_id = aws_security_group.bastions_sg.id
#
#}
#
#resource "aws_security_group_rule" "allow_icmp_inbound" {
#  type = "ingress"
#
#  security_group_id = aws_security_group.bastions_sg.id
#
#
#  from_port = local.any_port
#  to_port   = local.any_port
#  protocol  = "icmp"
#
#  cidr_blocks = local.my_ip
#}
#
#resource "aws_security_group_rule" "allow_icmp_inbound2" {
#  type = "ingress"
#
#  security_group_id = aws_security_group.web_sg.id
#
#  from_port = local.any_port
#  to_port   = local.any_port
#  protocol  = "icmp"
#
#  cidr_blocks = local.local_cidr
#}
#
#resource "aws_security_group_rule" "allow_http_inbound" {
#  type = "ingress"
#
#  security_group_id = aws_security_group.bastions_sg.id
#
#  from_port = local.http_port
#  to_port   = local.http_port
#  protocol  = "tcp"
#
#  cidr_blocks = local.all_ips
#}
#
#resource "aws_security_group_rule" "allow_http_inbound2" {
#  type = "ingress"
#
#  security_group_id = aws_security_group.web_sg.id
#
#  from_port = local.http_port
#  to_port   = local.http_port
#  protocol  = "tcp"
#
#  cidr_blocks = local.all_ips
#}
#
#
#
#resource "aws_security_group_rule" "allow_https_inbound" {
#  type = "ingress"
#
#  security_group_id = aws_security_group.bastions_sg.id
#
#  from_port = local.https_port
#  to_port   = local.https_port
#  protocol  = "tcp"
#
#  cidr_blocks = local.all_ips
#}
#
#resource "aws_security_group_rule" "allow_https_inbound2" {
#  type = "ingress"
#
#  security_group_id = aws_security_group.web_sg.id
#
#  from_port = local.https_port
#  to_port   = local.https_port
#  protocol  = "tcp"
#
#  cidr_blocks = local.all_ips
#}
#
#
#resource "aws_security_group_rule" "allow_all_outbound" {
#  type = "egress"
#
#  security_group_id = aws_security_group.bastions_sg.id
#
#  from_port = local.any_port
#  to_port   = local.any_port
#  protocol  = local.any_protocol
#
#  cidr_blocks = local.all_ips
#}
#
#
#
#
#data "terraform_remote_state" "db" {
#  backend = "s3"
#
#  config = {
#    bucket = var.db_remote_state_bucket
#    key    = var.db_remote_state_key
#    region = "ap-northeast-2"
#  }
#}
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ SG - END - @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
#
#data "aws_availability_zones" "selected" {
#  state = "available"
#
#  filter {
#    name   = "zone-name"
#    values = ["*a", "*c"]
#  }
#}
#
#
#resource "aws_instance" "bastion" {
#  ami             = "ami-05e02e6210658716f"
#  security_groups = [aws_security_group.bastions_sg.id]
#  instance_type   = "t2.micro"
#  subnet_id       = data.aws_subnet.pub_sn["SN-WEB-Pub-1"].id # 서브넷 ID 지정
#  key_name        = "wonsoong"
#
#  iam_instance_profile = aws_iam_instance_profile.instance.name
#
#  user_data = <<-EOF
#  #!/bin/bash
#  yum update -y
#  EOF
#
#  user_data_replace_on_change = true
#
#  tags = {
#    Name = "${var.cluster_name}-bastion"
#  }
#}
#
#
#
#resource "aws_instance" "web" {
#  ami             = "ami-05e02e6210658716f"
#  security_groups = [aws_security_group.web_sg.id]
#  instance_type   = "t2.micro"
#  subnet_id       = data.aws_subnet.pri_sn["SN-WEB-Pri-3"].id # 서브넷 ID 지정
#  key_name        = "wonsoong"
#
#  iam_instance_profile = aws_iam_instance_profile.instance.name
#
#  user_data_replace_on_change = true
#
#  root_block_device {
#    volume_type = "gp2"
#    volume_size = 20
#  }
#
#  tags = {
#    Name = "${var.cluster_name}-web"
#  }
#}
#
#
#resource "aws_eip" "bastion_eip" {
#  tags = {
#    Name = "${var.cluster_name}-bastion-eip"
#
#  }
#}
#
#resource "aws_eip_association" "bastion_eip_assoc" {
#  instance_id   = aws_instance.bastion.id
#  allocation_id = aws_eip.bastion_eip.id
#}
#
