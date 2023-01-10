resource "aws_instance" "bot_server" {
  ami                    = "ami-0039da1f3917fa8e3" #data.aws_ami.ubuntu.id
  instance_type          = var.type
  key_name               = var.ssh_key //used pregenerated privat key 
  vpc_security_group_ids = [aws_security_group.bot_sg.id]

  lifecycle {
    create_before_destroy = true
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/hosts"
  }

  tags = {
    "Name" = "bot_server"
  }
}
