module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.7"

  name = var.vpc_name
  cidr = var.vpc_cidr
  azs  = var.azs

  private_subnets = [
    cidrsubnet(var.vpc_cidr, 2, 0),
    cidrsubnet(var.vpc_cidr, 2, 1),
    cidrsubnet(var.vpc_cidr, 2, 2)
  ]
  database_subnets = [
    cidrsubnet(var.vpc_cidr, 4, 12),
    cidrsubnet(var.vpc_cidr, 4, 13),
    cidrsubnet(var.vpc_cidr, 4, 14)
  ]
  public_subnets = [
    cidrsubnet(var.vpc_cidr, 2, 3),
    cidrsubnet(var.vpc_cidr, 2, 4),
    cidrsubnet(var.vpc_cidr, 2, 5)
  ]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  one_nat_gateway_per_az = var.create_nat_per_az
  single_nat_gateway     = !var.create_nat_per_az

  enable_flow_log                      = true
  flow_log_destination_type            = "cloud-watch-logs"
  create_flow_log_cloudwatch_log_group = true
  flow_log_cloudwatch_log_group_retention_in_days = 90

  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}
