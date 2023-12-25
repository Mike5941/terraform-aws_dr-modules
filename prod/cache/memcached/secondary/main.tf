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
  region = "ap-northeast-1"
  alias = "secondary"
}


 data "terraform_remote_state" "secondary_vpc" {
   backend = "s3"

   config = {
     bucket = "terraform-wonsoong"
     key    = "prod/vpc/secondary/terraform.tfstate"
     region = "ap-northeast-2"
   }
 }

module "secondary_cache" {
  source = "../../../../modules/cache/memcached"

  cluster_id = "secondary-memcached"

  providers = {
    aws = aws.secondary
  }

  vpc_id = data.terraform_remote_state.secondary_vpc.outputs.vpc_id
}
