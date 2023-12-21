 resource "aws_security_group" "bastion" {
   name   = "${var.cluster_name}-bastion"
   vpc_id = local.vpc_id
 }

resource "aws_security_group" "instance" {
   name   = "${var.cluster_name}-instace"
   vpc_id = local.vpc_id

   ingress {
     from_port   = local.server_port
     to_port     = local.server_port
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
 }

 resource "aws_security_group" "alb" {
   name   = "${var.cluster_name}-alb"
   vpc_id = local.vpc_id
 }

 resource "aws_security_group_rule" "allow_http_inbound" {
   type = "ingress"

   security_group_id = aws_security_group.alb.id

   from_port   = local.http_port
   to_port     = local.http_port
   protocol    = local.tcp_protocol
   cidr_blocks = local.all_ips
 }

 resource "aws_security_group_rule" "allow_https_inbound" {
   type = "ingress"

   security_group_id = aws_security_group.alb.id

   from_port   = local.https_port
   to_port     = local.https_port
   protocol    = local.tcp_protocol
   cidr_blocks = local.all_ips
 }



 resource "aws_security_group_rule" "allow_icmp_inbound" {
   type = "ingress"

   security_group_id = aws_autoscaling_group.example

   from_port   = local.any_port
   to_port     = local.any_port
   protocol    = local.icmp_protocol
   cidr_blocks = local.my_ip
 }


 resource "aws_security_group_rule" "allow_all_outbound" {
   type              = "egress"
   security_group_id = [aws_security_group.alb.id, aws_security_group.bastion]

   from_port   = local.any_port
   to_port     = local.any_port
   protocol    = local.any_protocol
   cidr_blocks = local.all_ips
 }

