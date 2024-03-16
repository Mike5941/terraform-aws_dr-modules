#resource "aws_instance" "bastion_host" {
#  ami           = data.aws_ami.amazon_linux2.id  // Amazon Linux 2 AMI
#  instance_type = "t2.micro"
#  key_name      = "wonsoong"
#  subnet_id     = data.terraform_remote_state.vpc.outputs.public_subnet[0]
#  vpc_security_group_ids = [aws_security_group.bastion.id]
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  tags = {
#    Name = "Bastion Host"
#  }
#}

resource "aws_security_group" "bastion" {
  name = "bastion"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port = -1
  to_port = -1
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}