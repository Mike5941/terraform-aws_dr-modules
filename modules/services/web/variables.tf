data "aws_vpc" "prod-vpc" {
  tags = {
    Name = "prod-sel-vpc"
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

data "aws_subnet" "pri_sn" {
  for_each = toset(["SN-WEB-Pri-3", "SN-WEB-Pri-4"])

  filter {
    name   = "tag:Name"
    values = [each.value]
  }
}

data "aws_subnet" "pub_sn" {
  for_each = toset(["SN-WEB-Pub-1", "SN-WEB-Pub-2"])

  filter {
    name   = "tag:Name"
    values = [each.value]
  }
}

locals {
  vpc_id               = data.aws_vpc.prod-vpc.id
  vpc_cidr             = data.aws_vpc.prod-vpc.cidr_block
  vpc_subnets          = data.aws_subnet.pri_sn
  vpc_pub_subnets      = data.aws_subnet.pub_sn
  vpc_pub_subnet_ids   = [for s in data.aws_subnet.pub_sn : s.id]
  vpc_pri_subnet_ids   = [for s in data.aws_subnet.pri_sn : s.id]
  vpc_pub_subnet_azs   = [for s in data.aws_subnet.pub_sn : s.availability_zone]
  vpc_pri_subnet_azs   = [for s in data.aws_subnet.pri_sn : s.availability_zone]
  vpc_pub_subnet_cidrs = [for s in data.aws_subnet.pub_sn : s.cidr_block]
}

variable "cluster_name" {
  description = "The name of use for all the cluster resources"
  type        = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type        = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  default     = "t2.micro"
}
locals {
  ssh_port    = 22
  http_port   = 80
  https_port  = 443
  server_port = 8080

  local_cidr    = ["10.0.0.0/16"]
  icmp_protocol = "icmp"
  my_ip         = ["125.242.51.183/32"]
  any_port      = -1
  any_protocol  = "-1"
  tcp_protocol  = "tcp"
  all_ips       = ["0.0.0.0/0"]
}

 variable "min_size" {
   description = "The minimum number of services Instances in the ASG"
   default     = 2
 }

 variable "max_size" {
   description = "The maximum number of services Instances in the ASG"
   default     = 4
 }


 variable "custom_tags" {
   description = "Custom tags to set on the Instances in the ASG"
   type        = map(string)
   default     = {}
 }

 variable "enable_autoscaling" {
   description = "If set to true, enable auto scaling"
   type        = bool
 }

variable "ami" {
  description = "The AMI to run in the cluster"
  type        = string
  default     = "ami-086cae3329a3f7d75"
}

 variable "server_text" {
   description = "The text the web server should return"
   type        = string
   default     = "Hello, World"
 }

# variable "give_neo_cloudwatch_full_access" {
#   description = "If true, neo gets full access to CloudWatch"
#   type        = bool
# }
