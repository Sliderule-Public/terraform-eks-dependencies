module "infrastructure_bucket" {
  providers = {
    aws                          = aws
    aws.cross_region_replication = aws.cross_region_replication
  }
  source                           = "github.com/Modern-Logic/terraform-modules.git//simple/s3_bucket?ref=v1.10.8"
  environment                      = var.environment
  region                           = var.region
  replication_region               = var.cross_region_replication_region
  company_name                     = var.company_name
  account_id                       = local.account_id
  bucket_name                      = "infrastructure-eks"
  key_arn                          = module.main_key.key_arn
  tags                             = var.tags
  deploy_cross_region_read_replica = var.deploy_cross_region_read_replica
}

module "server_docs_bucket" {
  providers = {
    aws                          = aws
    aws.cross_region_replication = aws.cross_region_replication
  }
  source                           = "github.com/Modern-Logic/terraform-modules.git//simple/s3_bucket?ref=v1.10.8"
  environment                      = var.environment
  region                           = var.region
  replication_region               = var.cross_region_replication_region
  company_name                     = var.company_name
  account_id                       = local.account_id
  bucket_name                      = "server-documents"
  key_arn                          = module.main_key.key_arn
  upload_cors_rules_enabled        = true
  tags                             = var.tags
  deploy_cross_region_read_replica = var.deploy_cross_region_read_replica
}
