terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/vpc/secondary/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "tokyo"
}

module "secondary_zone" {
  source = "../../../modules/network"

  providers = {
    aws = aws.tokyo
  }

  project_name   = "WEB-Secondary"
  vpc_cidr_block = "10.2.0.0/16"
  subnets = {
    Pub-1 = {
      cidr                    = "10.2.1.0/24"
      az                      = "ap-northeast-1a"
      map_public_ip_on_launch = true
    },
    Pub-2 = {
      cidr                    = "10.2.2.0/24"
      az                      = "ap-northeast-1c"
      map_public_ip_on_launch = true
    },
    WEB-3 = {
      cidr                    = "10.2.3.0/24"
      az                      = "ap-northeast-1a"
      map_public_ip_on_launch = false
    },
    WEB-4 = {
      cidr                    = "10.2.4.0/24"
      az                      = "ap-northeast-1c"
      map_public_ip_on_launch = false
    },
    DB-5 = {
      cidr                    = "10.2.5.0/24"
      az                      = "ap-northeast-1a"
      map_public_ip_on_launch = false
    },
    DB-6 = {
      cidr                    = "10.2.6.0/24"
      az                      = "ap-northeast-1c"
      map_public_ip_on_launch = false
    }
  }
}
