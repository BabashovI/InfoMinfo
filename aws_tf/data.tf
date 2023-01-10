data "aws_regions" "current" {}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64*"]
  }
  #   filter {
  #     name = ""
  #   }
}

data "archive_file" "lamda_func" {
  type        = "zip"
  source_file = "../py_scripts/lambda_function.py"
  output_path = "../py_scripts/lambda_function.zip"
}
