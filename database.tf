module "rds_instance" {
  count = var.deploy_database == true ? 1 : 0
  source                   = "github.com/Modern-Logic/terraform-modules.git//simple/rds"
  environment              = var.environment
  company_name             = var.company_name
  region                   = var.region
  cluster_name             = "services"
  availability_zone        = local.database_az
  role_arn                 = module.rds_role.role_arn
  security_group           = module.rds_security_group.security_group_id
  private_subnets          = local.private_subnet_ids
  public_subnets           = local.public_subnet_ids
  tags                     = var.tags
  kms_key_arn              = module.rds_key.key_arn
  initial_database         = var.initial_database
  snapshot_identifier      = var.snapshot_identifier != "" ? var.snapshot_identifier : ""
  skip_final_snapshot      = var.skip_final_snapshot
  name_override            = "sliderule" # Workaround for compatibility issues with the other stack that uses this module, `ecs-app`
  sns_arn                  = aws_sns_topic.alarms.arn
  instance_type            = var.database_instance_type
  deploy_read_replica      = var.deploy_read_replica
  use_only_private_subnets = var.use_only_private_subnets
}
