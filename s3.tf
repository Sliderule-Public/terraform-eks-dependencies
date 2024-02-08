module "infrastructure_bucket" {
  providers = {
    aws                          = aws
    aws.cross_region_replication = aws.cross_region_replication
  }
  source             = "github.com/Modern-Logic/terraform-modules.git//simple/s3_bucket?ref=v1.10.2"
  environment        = var.environment
  region             = var.region
  replication_region = var.cross_region_replication_region
  company_name       = var.company_name
  account_id         = local.account_id
  bucket_name        = "infrastructure-eks"
  key_arn            = module.main_key.key_arn
  tags               = var.tags
}

module "server_docs_bucket" {
  providers = {
    aws                          = aws
    aws.cross_region_replication = aws.cross_region_replication
  }
  source                    = "github.com/Modern-Logic/terraform-modules.git//simple/s3_bucket?ref=v1.10.2"
  environment               = var.environment
  region                    = var.region
  replication_region        = var.cross_region_replication_region
  company_name              = var.company_name
  account_id                = local.account_id
  bucket_name               = "server-documents"
  key_arn                   = module.main_key.key_arn
  upload_cors_rules_enabled = true
  tags                      = var.tags
}
