data "aws_availability_zones" "zone_south" {}

data "aws_ami" "myami" {
  most_recent = "true"
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["*ubuntu-xenial-16.04-amd64-server*"]
  }

}

