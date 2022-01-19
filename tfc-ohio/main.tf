terraform {
  required_providers {
    aws = {
      version = ">= 3.22.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = "us-east-2"
}

variable "profile" { type = string }
variable "ami1" { type = string }
variable "ami2" { type = string }
variable "key-name" { type = string }
variable "subnet" { type = string }
variable "sg1" { type = string }
variable "sg2" { type = string }
variable "eip1" { type = string }
variable "eip2" { type = string }

resource "aws_instance" "wowza" {
  ami             = var.ami1
  key_name        = var.key-name
  instance_type   = "c5.2xlarge"
  subnet_id       = var.subnet
  security_groups = [var.sg1]
  private_ip      = "10.0.4.100"
  tags = {
    Name = "Wowza-Streaming-Engine"
  }
}

resource "aws_eip_association" "wowza-eip" {
  instance_id   = aws_instance.wowza.id
  allocation_id = var.eip1
}

resource "aws_instance" "switcher" {
  ami             = var.ami2
  key_name        = var.key-name
  instance_type   = "c5.2xlarge"
  subnet_id       = var.subnet
  security_groups = [var.sg2]
  tags = {
    Name = "Cloud-Switcher"
  }
}

resource "aws_eip_association" "switcher-eip" {
  instance_id   = aws_instance.switcher.id
  allocation_id = var.eip2
}
