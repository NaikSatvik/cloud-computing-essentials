terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.13.5"
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
}

# Create a Instance
resource "aws_instance" "vm" {
  ami                     = "ami-05912b6333beaa478"
  instance_type           = "t2.micro"
  key_name                = "win_instance_key"
  security_groups         = ["${aws_security_group.allow_rdp_http.name}"]
  disable_api_termination = true
  monitoring              = true

  tags = {
    Name = "Windows Server 2019"
  }
}
resource "aws_security_group" "allow_rdp_http" {
  name        = "allow_rdp_http"
  description = "Allows HTTP access"
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
