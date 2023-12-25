provider "aws" {
  alias = "primary"
  region = "ap-northeast-2" # 메인 리전
}

provider "aws" {
  alias  = "secondary"
  region = "ap-northeast-1" # 복제본을 만들 리전
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


module "primary_db" {
  source = "../../../modules/database/mysql"

  depends_on = [module.prod_db_secrets]

  providers = {
    aws = aws.primary
  }
  cluster_identifier = "primary-cluster"
  engine_type          = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.05.0"
  engine_mode = "provisioned"
  instance_class       = "db.t3.medium"
  db_name              = "Primary0731"
  db_subnet_group_name = "db-subnet-group"

  vpc_id = data.aws_vpc.primary.id
  instance_count = 2
  identifier_prefix    = "primary-zone"
  source_region = "ap-northeast-2"
  backup_retention_period = 10


  db_username = module.prod_db_secrets.db_credentials["username"]
  db_password = module.prod_db_secrets.db_credentials["password"]
}

module "secondary_db" {
  providers = {
    aws = aws.secondary
  }
  source = "../../../modules/database/mysql"

  cluster_identifier = "secondary-cluster"
  engine_type          = "aurora-mysql"
  engine_mode = "provisioned"
  engine_version = "8.0.mysql_aurora.3.05.0"

  instance_class       = "db.t3.medium"
  db_name              = "Secondary0731"
  db_subnet_group_name = "db-subnet-group"
  vpc_id = data.aws_vpc.secondary.id

  instance_count = 2
  identifier_prefix    = "secondary-zone"

  replication_source_identifier = module.primary_db.arn
}

