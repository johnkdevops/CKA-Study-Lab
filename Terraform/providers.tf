terraform {
  required_providers {
    localos = {
      source  = "fireflycons/localos"
      version = "0.1.2"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "localos" {}

# provider "ansible" {}

provider "aws" {
  region = var.aws_region[0]
}
