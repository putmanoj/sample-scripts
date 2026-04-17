variable "name_tag" {
  default = "My-Test-Volume"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "region" {
  default = "us-east-1"
}

provider "aws" {
  region = var.region
}

resource "aws_ebs_volume" "test_volume" {
  availability_zone = var.availability_zone
  size              = 10   # Initial size: 10 GB
  type              = "gp3"

  tags = {
    Name = var.name_tag
  }
}