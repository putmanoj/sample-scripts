provider "aws" {
  region = "us-east-1"
}

resource "aws_ebs_volume" "test_volume" {
  availability_zone = "us-east-1a"
  size              = 10   # Initial size: 10 GB
  type              = "gp3"

  tags = {
    Name = "Manoj-Test-Volume"
  }
}