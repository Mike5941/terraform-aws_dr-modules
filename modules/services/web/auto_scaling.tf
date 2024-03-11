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
    bucket = var.remote_state_bucket
    key    = var.vpc_remote_state_key
    region = local.seoul_region
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = ["SN-Pub-1"]
  }
}

data "aws_subnets" "web" {
  filter {
    name   = "tag:Name"
    values = ["SN-Web-3"]
  }
}

resource "aws_instance" "web" {
  count = length(data.aws_subnets.web.ids)
  ami           = data.aws_ami.amazon_linux2.id  // Amazon Linux 2 AMI
  instance_type = "t2.medium"
  key_name      = "wonsoong"
  subnet_id     = data.aws_subnets.web.ids[count.index]
  vpc_security_group_ids = [aws_security_group.wordpress.id]
  private_ip = "10.1.3.100"
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    db_name = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    db_host  = var.db_host
    db_port     = var.db_port
  }))

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.cluster_name}-WEB"
  }
}

#resource "aws_instance" "bastion_host" {
#  count = length(data.aws_subnets.public.ids)
#  ami           = data.aws_ami.amazon_linux2.id  // Amazon Linux 2 AMI
#  instance_type = "t2.micro"
#  key_name      = "wonsoong"
#  subnet_id     = data.aws_subnets.public.ids[count.index]
#  vpc_security_group_ids = [aws_security_group.bastion.id]
#
#  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
#
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  tags = {
#    Name = "Bastion Host"
#  }
#}

resource "aws_launch_template" "wordpress" {
  name = "${var.cluster_name}-template"
  image_id        = data.aws_ami.amazon_linux2.id
  instance_type   = "t2.micro"
  vpc_security_group_ids = [aws_security_group.wordpress.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_profile.name
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    db_name = "wordpress"
    db_username = var.db_username
    db_password = var.db_password
    db_host  = var.db_host
    db_port     = var.db_port
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-instance"
    }
  }
}

# resource "aws_autoscaling_group" "example" {
#   name                 = "${var.cluster_name}-${aws_launch_configuration.example.name}"
#   launch_configuration = aws_launch_configuration.example.name
#   vpc_zone_identifier  = local.vpc_pri_subnet_ids
#
#   target_group_arns = [aws_lb_target_group.asg.arn]
#   health_check_type = "ELB"
#
#   min_size = var.min_size
#   max_size = var.max_size
#
#   instance_refresh {
#     strategy = "Rolling"
#     preferences {
#       min_healthy_percentage = 50
#     }
#   }
#
#   tag {
#     key                 = "Name"
#     value               = var.cluster_name
#     propagate_at_launch = true
#   }
#
#   dynamic "tag" {
#     for_each = {
#       for key, value in var.custom_tags :
#       key => upper(value)
#       if key != "Name"
#     }
#
#     content {
#       key                 = tag.key
#       value               = tag.value
#       propagate_at_launch = true
#     }
#   }
# }

# resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
#   count = var.enable_autoscaling ? 1 : 0
#
#   scheduled_action_name  = "${var.cluster_name}-scale-out-during-business-hours"
#   min_size               = 2
#   max_size               = 10
#   desired_capacity       = 10
#   recurrence             = "0 9 * * *"
#   autoscaling_group_name = aws_autoscaling_group.example.name
# }

# resource "aws_autoscaling_schedule" "scale_in_at_night" {
#   count = var.enable_autoscaling ? 1 : 0
#
#   scheduled_action_name  = "${var.cluster_name}-scale-in-at-night"
#   min_size               = 3
#   max_size               = 10
#   desired_capacity       = 3
#   recurrence             = "0 17 * * *"
#   autoscaling_group_name = aws_autoscaling_group.example.name
# }

# resource "aws_lb" "example" {
#   name               = var.cluster_name
#   load_balancer_type = "application"
#   subnets            = local.vpc_pub_subnet_ids
#   security_groups    = [aws_security_group.alb.id]
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.example.arn
#   port              = local.http_port
#   protocol          = "HTTP"
#
#   default_action {
#     type = "fixed-response"
#
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "404: page not found"
#       status_code  = 404
#     }
#   }
# }

# resource "aws_lb_target_group" "asg" {
#   name     = "${var.cluster_name}-example"
#   port     = var.server_port
#   protocol = "HTTP"
#   vpc_id   = local.vpc_id
#
#   tags = {
#     Name = var.cluster_name
#   }
#
#   health_check {
#     path                = "/"
#     protocol            = "HTTP"
#     matcher             = "200"
#     interval            = 15
#     timeout             = 3
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
# }
#
#resource "aws_lb_listener_rule" "asg" {
#  listener_arn = aws_lb_listener.http.arn
#  priority     = 100
#
#  condition {
#    path_pattern {
#      values = ["*"]
#    }
#}
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.asg.arn
#  }
#}