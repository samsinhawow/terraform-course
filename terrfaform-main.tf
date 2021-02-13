variable "region" {
  default = "ap-south-1"
}

variable "private_key_file" {
  default = "/home/mtadmin123/keypairtrial.pem"
}

variable "security_group" {
  default = "sg-021c288a42cd6072c"
}

variable "key_name" {
  default = "keypairtrial"
}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.myami.id
  instance_type          = "t2.micro"
  count                  = 2
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group]

  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "Backend"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_file)
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sleep 30",
      "sudo apt-get update -y",
      "sudo apt-get install python sshpass -y"
    ]
  }
}

resource "null_resource" "ansible-main" {
  provisioner "local-exec" {
    command = <<EOT
       > terraform.ini;
       echo "[tomcat]"|tee -a terraform.ini;
       export ANSIBLE_HOST_KEY_CHECKING=False;
       echo "${aws_instance.backend[0].public_ip}"|tee -a terraform.ini;
       echo "${aws_instance.backend[1].public_ip}"|tee -a terraform.ini;
       ansible-playbook --private-key ${var.private_key_file} -i terraform.ini -u ubuntu ./ansible/playbook.yaml -v 
     EOT
  }
  depends_on = [aws_instance.backend]
}

