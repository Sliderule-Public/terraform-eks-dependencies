module "shared_vpc_cross_region" {
  providers = {
    aws = aws.cross_region_replication
  }
  count          = var.create_vpc && var.deploy_cross_region_read_replica && var.cross_region_vpc_id == "" ? 1 : 0
  source         = "github.com/Modern-Logic/terraform-modules.git//composite/vpc?ref=v1.9"
  environment    = var.environment
  company_name   = var.company_name
  vpc_cidr_block = var.cross_region_vpc_cidr
  kms_key_arn    = module.main_key_cross_region[0].key_arn
  vpc_name       = "services-cross-region"
  region         = var.region
  tags           = var.tags
}

module "rds_security_group_cross_region" {
  providers = {
    aws = aws.cross_region_replication
  }
  count               = var.deploy_cross_region_read_replica ? 1 : 0
  source              = "github.com/Modern-Logic/terraform-modules.git//simple/vpc_security_group?ref=v1.12.5"
  environment         = var.environment
  company_name        = var.company_name
  region              = var.region
  tags                = var.tags
  security_group_name = "rds"
  vpc_id              = local.cross_region_vpc_id
  ingress_rules       = var.use_only_private_subnets == false ? concat(local.cross_region_rds_default_security_group_rules, local.auth_security_group_rules) : local.cross_region_rds_default_security_group_rules
}
