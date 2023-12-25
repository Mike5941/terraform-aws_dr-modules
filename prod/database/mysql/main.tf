terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/database/mysql/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-2"
  alias = "primary"
}

provider "aws" {
  region = "ap-northeast-1"
  alias = "secondary"
}

module "db_secrets" {
  source      = "../../../global/secrets"
  secret_name = "MyDatabaseSecret"
}

module "primary" {
  source = "../../../modules/database/mysql"

  providers ={
    aws = aws.primary
  }

  db_name              = "primary0731s"
  db_subnet_group_name = "db-subnet-group"
  vpc_id = data.aws_vpc.primary.id
  backup_retention_period = 1

  db_username = module.db_secrets.db_credentials["username"]
  db_password = module.db_secrets.db_credentials["password"]
}

module "replica" {
  source = "../../../modules/database/mysql"

  providers = {
    aws = aws.secondary
  }

  vpc_id = data.aws_vpc.secondary.id
  db_subnet_group_name = "db-subnet-group"

  replicate_source_db = module.primary.arn
}