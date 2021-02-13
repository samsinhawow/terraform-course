variable "region" {
  default = "ap-south-1"
}

provider "aws" {
  region  = var.region
  version = ">=3.7,<=3.11"
}
