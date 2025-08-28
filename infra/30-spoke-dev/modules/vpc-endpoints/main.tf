module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.7"

  vpc_id             = var.vpc_id
  security_group_ids = []

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = var.route_table_ids
      tags           = merge(var.tags, { Name = "vpce-s3" })
    }
    ecr_api = { 
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = var.subnet_ids
      tags                = merge(var.tags, { Name = "vpce-ecr-api" })
    }
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = var.subnet_ids
      tags                = merge(var.tags, { Name = "vpce-ecr-dkr" })
    }
    logs = {
      service             = "logs"
      private_dns_enabled = true
      subnet_ids          = var.subnet_ids
      tags                = merge(var.tags, { Name = "vpce-logs" })
    }
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = var.subnet_ids
      tags                = merge(var.tags, { Name = "vpce-sts" })
    }
    kms = {
      service             = "kms"
      private_dns_enabled = true
      subnet_ids          = var.subnet_ids
      tags                = merge(var.tags, { Name = "vpce-kms" })
    }
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = var.subnet_ids
      tags                = merge(var.tags, { Name = "vpce-ssm" })
    }
    secrets = {
      service             = "secretsmanager"
      private_dns_enabled = true
      subnet_ids          = var.subnet_ids
      tags                = merge(var.tags, { Name = "vpce-secrets" })
    }
    sqs = {
      service             = "sqs"
      private_dns_enabled = true
      subnet_ids          = var.subnet_ids
      tags                = merge(var.tags, { Name = "vpce-sqs" })
    }
  }

  tags = var.tags
}
