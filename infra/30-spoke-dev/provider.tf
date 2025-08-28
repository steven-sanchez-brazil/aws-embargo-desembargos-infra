terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.40" }
  }
}
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "DIAN-Embargos"
      Component   = "networking"
      Terraform   = "true"
    }
  }
}