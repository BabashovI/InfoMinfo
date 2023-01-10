# output "region" {
#   value = data.aws_regions.current.names
# }

output "public_ip" {
  value = aws_instance.bot_server.public_ip
}

# output "amis" {
#   value = data.aws_ami.ubuntu.id
# }
