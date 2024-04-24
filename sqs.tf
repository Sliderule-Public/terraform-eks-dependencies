module "sqs" {
  source       = "github.com/Modern-Logic/terraform-modules.git//simple/sqs_queue?ref=v1.13.0"
  environment  = var.environment
  company_name = var.company_name
  name         = "sls"
  tags         = var.tags
}
