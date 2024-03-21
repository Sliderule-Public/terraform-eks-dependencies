module "shared_vpc" {
  count          = var.create_vpc == true ? 1 : 0
  source         = "github.com/Modern-Logic/terraform-modules.git//composite/vpc"
  environment    = var.environment
  company_name   = var.company_name
  vpc_cidr_block = var.app_vpc_cidr
  kms_key_arn    = module.main_key.key_arn
  vpc_name       = "services"
  region         = var.region
  tags           = var.tags
}


module "rds_security_group" {
  source              = "github.com/Modern-Logic/terraform-modules.git//simple/vpc_security_group?ref=v1.12.5"
  environment         = var.environment
  region              = var.region
  company_name        = var.company_name
  tags                = var.tags
  security_group_name = "rds"
  vpc_id              = local.vpc_id
  ingress_rules       = var.use_only_private_subnets == false ? concat(local.rds_default_security_group_rules, local.auth_security_group_rules) : local.rds_default_security_group_rules
}

locals {
  rds_default_security_group_rules = concat(var.database_security_group_additional_rules, [
    {
      description = "All traffic from private VPC"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = var.app_vpc_cidr
    }
  ])
  cross_region_rds_default_security_group_rules = concat(var.cross_region_database_security_group_additional_rules, [
    {
      description = "All traffic from private VPC"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = var.cross_region_vpc_cidr
    }
  ])
  auth_security_group_rules = [
    {
      description = "Auth0"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "18.232.225.224/32"
    },
    {
      description = "Auth0"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "34.233.19.82/32"
    },
    {
      description = "Auth0"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "52.204.128.250/32"
    },
    {
      description = "Auth0"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "3.132.201.78/32"
    },
    {
      description = "Auth0"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "3.19.44.88/32"
    },
    {
      description = "Auth0"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_block  = "3.20.244.231/32"
    }
  ]
}
