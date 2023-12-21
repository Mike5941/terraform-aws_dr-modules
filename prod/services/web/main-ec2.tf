module "web-instance" {
  source = "../../../modules/services/web"

  cluster_name = "webservers-prod"

  db_remote_state_bucket = "terraform-wonsoong"
  db_remote_state_key    = "prod/database/mysql/terraform.tfstate"
}

terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/services/web/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}
