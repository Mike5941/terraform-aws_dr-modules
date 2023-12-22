provider "aws" {
  region = "ap-northeast-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/database/mysql/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

module "prod_db_secrets" {
  source      = "../../../global/secrets"
  secret_name = "MyDatabaseSecret"
}

module "prod_db" {
  source = "../../../modules/database/mysql"

  identifier_prefix    = "primary-zone"
  engine_type          = "mysql"
  volume_size          = 10
  instance_class       = "db.t2.micro"
  skip_final_snapshot  = true
  db_name              = "PZN"
  db_subnet_group_name = "db-subnet-group"

  db_username = module.prod_db_secrets.db_credentials["username"]
  db_password = module.prod_db_secrets.db_credentials["password"]
}

