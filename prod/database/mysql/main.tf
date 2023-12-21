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

  identifier_prefix    = "prod-databse"
  engine_type          = "mysql"
  volume_size          = 10
  instance_class       = "db.t2.micro"
  skip_final_snapshot  = true
  db_name              = "prod"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  db_username = module.prod_db_secrets.db_credentials["username"]
  db_password = module.prod_db_secrets.db_credentials["password"]
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = local.rds_subnet_ids

  tags = {
    Nmae = "My DB Subnet Group"
  }
}

