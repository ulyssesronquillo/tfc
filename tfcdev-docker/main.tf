terraform {
  required_providers {
    aws = {
      version = ">= 3.22.0"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "tfc"
  region  = "us-east-2"
}

resource "aws_lightsail_instance" "tfcdev" {
  name               = "tfcdev"
  availability_zone  = "us-east-2a"
  blueprint_id       = "amazon_linux_2"
  bundle_id          = "micro_2_0"
  tags               = {
    name="tfcdev" 
    version="0.1"
  }
}

output "public_ip" {
  value = aws_lightsail_instance.tfcdev.public_ip_address
}

