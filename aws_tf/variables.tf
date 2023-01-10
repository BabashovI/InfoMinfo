variable "region" {
  default = "eu-central-1"
}

variable "ssh_key" {
  default = "bot_srv"
}

variable "type" {
  default = "t2.micro"
}

variable "cron" {
  default = {
    "start" : "cron(00 08 * * ? *)",
    "stop" : "cron(00 09 * * ? *)"
  }
}
