terraform {
  backend "s3" {
    bucket = "terraform-wonsoong"
    key    = "prod/vpc/terraform.tfstate"
    region = "ap-northeast-2"

    dynamodb_table = "terraform-wonsoong"
    encrypt        = true
  }
}

module "main_zone" {
  source = "../../../modules/network"

  providers = {
    aws = aws.seoul
  }

  project_name   = "WEB-DR-Main"
  vpc_cidr_block = "10.1.0.0/16"
  subnets = {
    Pub-Sub-1 = {
      cidr                    = "10.1.1.0/24"
      az                      = "ap-northeast-2a"
      map_public_ip_on_launch = true
    },
    Pub-Sub-2 = {
      cidr                    = "10.1.2.0/24"
      az                      = "ap-northeast-2c"
      map_public_ip_on_launch = true
    },
    Web-Sub-3 = {
      cidr                    = "10.1.3.0/24"
      az                      = "ap-northeast-2a"
      map_public_ip_on_launch = false
    },
    Web-Sub-4 = {
      cidr                    = "10.1.4.0/24"
      az                      = "ap-northeast-2c"
      map_public_ip_on_launch = false
    },
    DB-Sub-5 = {
      cidr                    = "10.1.5.0/24"
      az                      = "ap-northeast-2a"
      map_public_ip_on_launch = false
    },
    DB-Sub-6 = {
      cidr                    = "10.1.6.0/24"
      az                      = "ap-northeast-2c"
      map_public_ip_on_launch = false
    }
  }
}

