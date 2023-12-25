terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/cache/memcached/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-2"
  alias = "primary"
}

 data "terraform_remote_state" "primary_vpc" {
   backend = "s3"

   config = {
     bucket = "terraform-wonsoong"
     key    = "prod/vpc/primary/terraform.tfstate"
     region = "ap-northeast-2"
   }
 }

module "primary_cache" {
  source = "../../../../modules/cache/memcached"

  providers = {
    aws = aws.primary
  }

  cluster_id = "primary-memcached"

  vpc_id = data.terraform_remote_state.primary_vpc.outputs.vpc_id
}