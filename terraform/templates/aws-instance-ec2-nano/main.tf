# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

variable "stack_name" {
  type    = string
  default = "mp-sample-vm1"
}

resource "aws_instance" "web" {
  ami           = "ami-03e9149278a6f457c"
  instance_type = "t3.nano"

  tags = {
    Name = var.stack_name
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}