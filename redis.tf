module "redis_security_group" {
  source              = "github.com/Modern-Logic/terraform-modules.git//simple/vpc_security_group"
  environment         = var.environment
  company_name        = var.company_name
  tags                = var.tags
  security_group_name = "redis-eks"
  vpc_id              = local.vpc_id
  ingress_rules = [
    {
      description = "All traffic"
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      cidr_block  = var.app_vpc_cidr
    }
  ]
}

module "redis" {
  source             = "github.com/Modern-Logic/terraform-modules.git//simple/redis"
  environment        = var.environment
  company_name       = var.company_name
  name               = "redis"
  tags               = var.tags
  security_group_ids = [module.redis_security_group.security_group_id]
  subnet_ids         = local.private_subnet_ids
  node_type          = var.redis_node_type
}
