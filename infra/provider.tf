
variable "region" {
  default = "us-east-1"
}
//variable "profile" {
//  default = "187135145853_heimdall-admin"
//}


# terraform {
#   required_providers {
#     postgresql = {
#       source = "cyrilgdn/postgresql"
#       version = "1.11.1"
#     }
#   }
# }
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
    organization = "wwt-hyd"
  }
  workspaces {
    name = "quick-restaurant"
  }
}
provider "aws" {
//  profile                 = var.profile
//  shared_credentials_file = "~/.aws/credentials"
  region                  = var.region
}
