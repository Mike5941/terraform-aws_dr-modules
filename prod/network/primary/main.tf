terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/vpc/primary/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "tokyo"
}

provider "aws" {
  region = "ap-northeast-2"
  alias  = "seoul"
}

module "main_zone" {
  source = "../../../modules/network"

  providers = {
    aws = aws.seoul
  }

  project_name   = "WEB-Primary"
  vpc_cidr_block = "10.1.0.0/16"
  subnets = {
    Pub-1 = {
      cidr                    = "10.1.1.0/24"
      az                      = "ap-northeast-2a"
      map_public_ip_on_launch = true
    },
    Pub-2 = {
      cidr                    = "10.1.2.0/24"
      az                      = "ap-northeast-2c"
      map_public_ip_on_launch = true
    },
    Web-3 = {
      cidr                    = "10.1.3.0/24"
      az                      = "ap-northeast-2a"
      map_public_ip_on_launch = false
    },
    Web-4 = {
      cidr                    = "10.1.4.0/24"
      az                      = "ap-northeast-2c"
      map_public_ip_on_launch = false
    },
    DB-5 = {
      cidr                    = "10.1.5.0/24"
      az                      = "ap-northeast-2a"
      map_public_ip_on_launch = false
    },
    DB-6 = {
      cidr                    = "10.1.6.0/24"
      az                      = "ap-northeast-2c"
      map_public_ip_on_launch = false
    }
  }
}

