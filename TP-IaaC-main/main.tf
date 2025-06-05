terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "fcs_frontend" {
  ami           = "ami-0dd574ef87b79ac6c"
  instance_type = "t3.micro"
  key_name = "terraform_ec2_key"

  tags = {
    Name = "FCS-Frontend"
  }
}

resource "aws_instance" "fcs_backend" {
  ami           = "ami-0dd574ef87b79ac6c"
  instance_type = "t3.micro"
  key_name = "terraform_ec2_key"

  tags = {
    Name = "FCS-Backend"
  }
}

resource "aws_key_pair" "terraform_ec2_key" {
  key_name = "terraform_ec2_key"
  public_key = "${file("terraform_ec2_key.pub")}"
}