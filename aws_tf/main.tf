# #The configuration for the `remote` backend.
# resource "aws_s3_bucket" "infominfo-tfstate" {
#   bucket = "infominfo-tfstate"
#   lifecycle {
#     prevent_destroy = true
#   }
#   tags = {
#     Name = "infominfo-tfstate"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "public_access" {
#   bucket                  = aws_s3_bucket.infominfo-tfstate.id
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }
# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "tfstate-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
terraform {
  backend "s3" {
    bucket = "infominfo-tfstate"
    key    = "state/terraform.tfstate"
    region = "eu-central-1"
  }
}
# terraform {
#   backend "remote" {
#     # The name of your Terraform Cloud organization.
#     organization = "InfoMinfo"

#     # The name of the Terraform Cloud workspace to store Terraform state files in.
#     workspaces {
#       name = "InfoMinfo"
#     }
#   }
# }

#426ad477219725341531b31471b27c144f335fae4d776349fa826b35c60161f5_1 
