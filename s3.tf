module "infrastructure_bucket" {
  count     = var.deploy_s3_buckets ? 1 : 0
  providers = {
    aws                          = aws
    aws.cross_region_replication = aws.cross_region_replication
  }
  source                           = "github.com/Modern-Logic/terraform-modules.git//simple/s3_bucket?ref=v1.13.6"
  environment                      = var.environment
  region                           = var.region
  replication_region               = var.cross_region_replication_region
  company_name                     = var.company_name
  account_id                       = local.account_id
  bucket_name                      = "infrastructure-eks"
  key_arn                          = module.main_key.key_arn
  tags                             = var.tags
  deploy_cross_region_read_replica = var.deploy_cross_region_bucket
}

module "server_docs_bucket" {
  count     = var.deploy_s3_buckets ? 1 : 0
  providers = {
    aws                          = aws
    aws.cross_region_replication = aws.cross_region_replication
  }
  source                           = "github.com/Modern-Logic/terraform-modules.git//simple/s3_bucket?ref=v1.13.6"
  environment                      = var.environment
  region                           = var.region
  replication_region               = var.cross_region_replication_region
  company_name                     = var.company_name
  account_id                       = local.account_id
  bucket_name                      = "server-documents"
  key_arn                          = module.main_key.key_arn
  upload_cors_rules_enabled        = true
  tags                             = var.tags
  deploy_cross_region_read_replica = var.deploy_cross_region_bucket
}

moved {
  from = module.infrastructure_bucket
  to   = module.infrastructure_bucket[0]
}

moved {
  from = module.server_docs_bucket
  to   = module.server_docs_bucket[0]
}