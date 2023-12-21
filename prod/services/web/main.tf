# provider "aws" {
#   region = "ap-northeast-2"
#   default_tags {
#     tags = {
#       Owner     = "team-foo"
#       ManagedBy = "Terraform"
#     }
#   }
# }

# terraform {
#   backend "s3" {
#     bucket = "terraform-wonsoong"
#     key    = "prod/services/web/terraform.tfstate"
#     region = "ap-northeast-2"

#     dynamodb_table = "terraform-wonsoong"
#     encrypt        = true
#   }
# }

# module "webserver_cluster" {
#   source = "../../../modules/services/web"

#   ami         = "ami-086cae3329a3f7d75"
#   server_text = "New server text3"

#   cluster_name           = "webservers-prod"
#   db_remote_state_bucket = "terraform-wonsoong"
#   db_remote_state_key    = "prod/database/mysql/terraform.tfstate"

#   instance_type      = "t3.medium"
#   min_size           = 2
#   max_size           = 10
#   enable_autoscaling = true

#   give_neo_cloudwatch_full_access = true
# }

