terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/vpc/terraform.tfstate"
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
  source = "../../modules/network"

  providers = {
    aws = aws.seoul
  }

  project_name   = "DR_main"
  vpc_cidr_block = "10.1.0.0/16"
  subnets = {
    Bastion-Pub-1 = {
      cidr                    = "10.1.1.0/24"
      az                      = "ap-northeast-2a"
      map_public_ip_on_launch = true
    },
    Bastion-Pub-2 = {
      cidr                    = "10.1.2.0/24"
      az                      = "ap-northeast-2c"
      map_public_ip_on_launch = true
    },
    WEB-Pri-3 = {
      cidr                    = "10.1.3.0/24"
      az                      = "ap-northeast-2a"
      map_public_ip_on_launch = false
    },
    WEB-Pri-4 = {
      cidr                    = "10.1.4.0/24"
      az                      = "ap-northeast-2c"
      map_public_ip_on_launch = false
    },
    RDS-5 = {
      cidr                    = "10.1.5.0/24"
      az                      = "ap-northeast-2a"
      map_public_ip_on_launch = false
    },
    RDS-6 = {
      cidr                    = "10.1.6.0/24"
      az                      = "ap-northeast-2c"
      map_public_ip_on_launch = false
    }
  }
}

#module "redundant_zone" {
#  source = "../../modules/network"
#
#  providers = {
#    aws = aws.tokyo
#
#  }
#  project_name   = "DR_Redund"
#  vpc_cidr_block = "10.2.0.0/16"
#  subnets = {
#    WEB-Pub-1 = {
#      cidr                    = "10.2.1.0/24"
#      az                      = "ap-northeast-1a"
#      map_public_ip_on_launch = true
#    },
#    WEB-Pub-2 = {
#      cidr                    = "10.2.2.0/24"
#      az                      = "ap-northeast-1c"
#      map_public_ip_on_launch = true
#    },
#    WEB-Pri-3 = {
#      cidr                    = "10.2.3.0/24"
#      az                      = "ap-northeast-1a"
#      map_public_ip_on_launch = false
#    },
#    WEB-Pri-4 = {
#      cidr                    = "10.2.4.0/24"
#      az                      = "ap-northeast-1c"
#      map_public_ip_on_launch = false
#    },
#    RDS-Pri-5 = {
#      cidr                    = "10.2.5.0/24"
#      az                      = "ap-northeast-1a"
#      map_public_ip_on_launch = false
#    },
#    RDS-Pri-6 = {
#      cidr                    = "10.2.6.0/24"
#      az                      = "ap-northeast-1c"
#      map_public_ip_on_launch = false
#    }
#  }
#}
