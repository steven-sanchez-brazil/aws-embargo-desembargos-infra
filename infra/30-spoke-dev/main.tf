locals {
  tags = {
    project = "DIAN-Embargos"
    env     = "dev"
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name         = "vpc-desembargos-dev"
  vpc_cidr         = var.vpc_cidr
  azs              = var.azs
  create_nat_per_az = var.create_nat_per_az
  tags             = local.tags
}

module "tgw" {
  source = "./modules/tgw"

  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets
  tgw_id                  = var.tgw_id
  onprem_cidrs            = var.onprem_cidrs
  private_route_table_ids = module.vpc.private_route_table_ids
  database_route_table_ids = module.vpc.database_route_table_ids
  tags                    = local.tags
}

module "vpc_endpoints" {
  source = "./modules/vpc-endpoints"

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  route_table_ids = concat(module.vpc.private_route_table_ids, module.vpc.database_route_table_ids)
  tags            = local.tags
}
