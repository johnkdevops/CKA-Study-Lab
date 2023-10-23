terraform {
  required_providers {
    localos = {
      source = "registry.terraform.io/fireflycons/localos"
    }
  }
}

provider "localos" {}

provider "aws" {
  region = var.aws_region
}
