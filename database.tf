module "rds_instance" {
  providers = {
    aws                          = aws
    aws.cross_region_replication = aws.cross_region_replication
  }
  count                            = var.deploy_database == true ? 1 : 0
  source                           = "github.com/Modern-Logic/terraform-modules.git//simple/rds?ref=v1.13.2"
  environment                      = var.environment
  company_name                     = var.company_name
  region                           = var.region
  cluster_name                     = "services"
  availability_zone                = local.database_az
  role_arn                         = module.rds_role.role_arn
  security_group                   = module.rds_security_group.security_group_id
  cross_region_security_group      = var.deploy_cross_region_read_replica ? module.rds_security_group_cross_region[0].security_group_id : ""
  private_subnets                  = local.private_subnet_ids
  public_subnets                   = local.public_subnet_ids
  cross_region_private_subnets     = local.cross_region_private_subnet_ids
  cross_region_public_subnets      = local.cross_region_public_subnet_ids
  tags                             = var.tags
  kms_key_arn                      = module.rds_key.key_arn
  cross_region_kms_key_arn         = var.deploy_cross_region_read_replica ? module.rds_key_cross_region[0].key_arn : ""
  initial_database                 = var.initial_database
  snapshot_identifier              = var.snapshot_identifier != "" ? var.snapshot_identifier : ""
  skip_final_snapshot              = var.skip_final_snapshot
  name_override                    = "sliderule"
  sns_arn                          = aws_sns_topic.alarms.arn
  instance_type                    = var.database_instance_type
  deploy_read_replica              = var.deploy_read_replica
  deploy_cross_region_read_replica = var.deploy_cross_region_read_replica
  use_only_private_subnets         = var.use_only_private_subnets
  rds_engine_version               = var.rds_engine_version
  database_max_allocated_storage   = var.database_max_allocated_storage
  rds_auto_minor_version_upgrade   = var.rds_auto_minor_version_upgrade
  parameter_group_major_version    = var.parameter_group_major_version
}
