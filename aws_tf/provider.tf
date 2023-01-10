#terraform {
 # required_providers {
  #  aws = {
   #   source  = "hashicorp/aws"
    #  version = "~> 4.4"
    #}
  #}
#}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Owner   = "Ibrahim.B"
      Project = "InfoMinfo"
    }
  }
}
