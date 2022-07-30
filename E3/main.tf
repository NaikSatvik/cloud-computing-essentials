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
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOUR_SECRET_KEY"
}

# Create a Instance
resource "aws_instance" "vm" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  key_name      = "MyKey"
  tags = {
    Name = "AMI Linux 2 ~ EBS storage"
  }
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = aws_instance.vm.availability_zone
  size              = 10
  type              = "gp2"
  tags = {
    Name = "ebs-volume-e4"
  }
}

resource "aws_volume_attachment" "ebs_volume_attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.vm.id
}
output "EbsVolumeId" {
  value = aws_ebs_volume.ebs_volume.id
}
output "InstanceId" {
  value = aws_instance.vm.id
}
