 resource "aws_launch_configuration" "example" {
   image_id        = var.ami
   instance_type   = var.instance_type
   security_groups = [aws_security_group.instance.id]

   user_data = templatefile("${path.module}/user-data.sh", {
     server_port = var.server_port
     db_address  = data.terraform_remote_state.db.outputs.address
     db_port     = data.terraform_remote_state.db.outputs.port
     server_text = var.server_text
   })

 }

 resource "aws_autoscaling_group" "example" {
   name                 = "${var.cluster_name}-${aws_launch_configuration.example.name}"
   launch_configuration = aws_launch_configuration.example.name
   vpc_zone_identifier  = local.vpc_pri_subnet_ids

   target_group_arns = [aws_lb_target_group.asg.arn]
   health_check_type = "ELB"

   min_size = var.min_size
   max_size = var.max_size

   instance_refresh {
     strategy = "Rolling"
     preferences {
       min_healthy_percentage = 50
     }
   }

   tag {
     key                 = "Name"
     value               = var.cluster_name
     propagate_at_launch = true
   }

   dynamic "tag" {
     for_each = {
       for key, value in var.custom_tags :
       key => upper(value)
       if key != "Name"
     }

     content {
       key                 = tag.key
       value               = tag.value
       propagate_at_launch = true
     }
   }
 }




 resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
   count = var.enable_autoscaling ? 1 : 0

   scheduled_action_name  = "${var.cluster_name}-scale-out-during-business-hours"
   min_size               = 2
   max_size               = 10
   desired_capacity       = 10
   recurrence             = "0 9 * * *"
   autoscaling_group_name = aws_autoscaling_group.example.name
 }

 resource "aws_autoscaling_schedule" "scale_in_at_night" {
   count = var.enable_autoscaling ? 1 : 0

   scheduled_action_name  = "${var.cluster_name}-scale-in-at-night"
   min_size               = 3
   max_size               = 10
   desired_capacity       = 3
   recurrence             = "0 17 * * *"
   autoscaling_group_name = aws_autoscaling_group.example.name
 }

 resource "aws_lb" "example" {
   name               = var.cluster_name
   load_balancer_type = "application"
   subnets            = local.vpc_pub_subnet_ids
   security_groups    = [aws_security_group.alb.id]
 }

 resource "aws_lb_listener" "http" {
   load_balancer_arn = aws_lb.example.arn
   port              = local.http_port
   protocol          = "HTTP"

   default_action {
     type = "fixed-response"

     fixed_response {
       content_type = "text/plain"
       message_body = "404: page not found"
       status_code  = 404
     }
   }
 }

 resource "aws_lb_target_group" "asg" {
   name     = "${var.cluster_name}-example"
   port     = var.server_port
   protocol = "HTTP"
   vpc_id   = local.vpc_id

   tags = {
     Name = var.cluster_name
   }

   health_check {
     path                = "/"
     protocol            = "HTTP"
     matcher             = "200"
     interval            = 15
     timeout             = 3
     healthy_threshold   = 2
     unhealthy_threshold = 2
   }
 }

 resource "aws_lb_listener_rule" "asg" {
   listener_arn = aws_lb_listener.http.arn
   priority     = 100

   condition {
     path_pattern {
       values = ["*"]
     }
   }

   action {
     type             = "forward"
     target_group_arn = aws_lb_target_group.asg.arn
   }
 }

 data "terraform_remote_state" "db" {
   backend = "s3"

   config = {
     bucket = var.db_remote_state_bucket
     key    = var.db_remote_state_key
     region = "ap-northeast-2"
   }
 }
