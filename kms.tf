locals {
  additional_grantee_arns = var.deploy_cross_region_bucket ? [
    module.infrastructure_bucket.replication_role_arn,
    module.server_docs_bucket.replication_role_arn
  ] : []
}

module "main_key" {
  source             = "github.com/Modern-Logic/terraform-modules.git//simple/kms_key?ref=v1.13.0"
  environment        = var.environment
  region             = var.region
  company_name       = var.company_name
  account_id         = local.account_id
  key_name           = "main-key"
  tags               = var.tags
  policy             = data.aws_iam_policy_document.main_kms_key.json
  usage_grantee_arns = concat(var.kms_grantees, local.additional_grantee_arns, [
    module.rds_role.role_arn,
    local.task_role_to_grant_kms_access,
  ])
}

module "main_key_cross_region" {
  providers = {
    aws = aws.cross_region_replication
  }
  count              = var.create_vpc ? 1 : 0
  source             = "github.com/Modern-Logic/terraform-modules.git//simple/kms_key?ref=v1.13.0"
  environment        = var.environment
  region             = var.region
  company_name       = var.company_name
  account_id         = local.account_id
  key_name           = "main-key-cross-region"
  tags               = var.tags
  policy             = data.aws_iam_policy_document.main_kms_key.json
  usage_grantee_arns = concat(var.kms_grantees, local.additional_grantee_arns, [
    module.rds_role.role_arn,
    local.task_role_to_grant_kms_access,
  ])
}

module "rds_key" {
  source             = "github.com/Modern-Logic/terraform-modules.git//simple/kms_key?ref=v1.13.0"
  environment        = var.environment
  region             = var.region
  company_name       = var.company_name
  account_id         = local.account_id
  key_name           = "rds-key"
  tags               = var.tags
  usage_grantee_arns = concat(var.kms_grantees, [
    module.rds_role.role_arn
  ])
}

module "rds_key_cross_region" {
  providers = {
    aws = aws.cross_region_replication
  }
  count              = var.deploy_cross_region_read_replica ? 1 : 0
  source             = "github.com/Modern-Logic/terraform-modules.git//simple/kms_key?ref=v1.13.0"
  environment        = var.environment
  region             = var.region
  company_name       = var.company_name
  account_id         = local.account_id
  key_name           = "rds-key"
  tags               = var.tags
  usage_grantee_arns = concat(var.kms_grantees, [
    module.rds_role.role_arn
  ])
}

data "aws_iam_policy_document" "main_kms_key" {
  statement {
    effect  = "Allow"
    actions = [
      "kms:*"
    ]
    resources = [
      "*"
    ]
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
  }
  statement {
    effect  = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = [
      "*"
    ]
    principals {
      identifiers = [
        "logs.us-west-1.amazonaws.com",
        "logs.us-west-2.amazonaws.com",
        "logs.us-east-1.amazonaws.com",
        "logs.us-east-2.amazonaws.com"
      ]
      type = "Service"
    }
  }

  # Additional services to grant access. One example is SES
  dynamic statement {
    for_each = length(var.services_to_grant_kms_access_to) > 0 ? [1] : []
    content {
      effect  = "Allow"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = [
        "*"
      ]
      principals {
        identifiers = var.services_to_grant_kms_access_to
        type        = "Service"
      }
    }
  }
}

module "sns_key" {
  source             = "github.com/Modern-Logic/terraform-modules.git//simple/kms_key?ref=v1.13.0"
  environment        = var.environment
  region             = var.region
  company_name       = var.company_name
  account_id         = local.account_id
  key_name           = "sns-key"
  tags               = var.tags
  policy             = data.aws_iam_policy_document.sns_kms_key.json
  usage_grantee_arns = concat(var.kms_grantees, [
    local.task_role_to_grant_kms_access
  ])
}

data "aws_iam_policy_document" "sns_kms_key" {
  statement {
    effect  = "Allow"
    actions = [
      "kms:*"
    ]
    resources = [
      "*"
    ]
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
  }
  statement {
    effect  = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = [
      "*"
    ]
    principals {
      identifiers = [
        "cloudwatch.amazonaws.com",
        "events.amazonaws.com",
        "events.rds.amazonaws.com",
        "logs.${var.region}.amazonaws.com"
      ]
      type = "Service"
    }
  }

  # Additional services to grant access. One example is SES
  dynamic "statement" {
    for_each = length(var.iam_arns_to_grant_sns_kms_access_to) > 0 ? [1] : []
    content {
      effect  = "Allow"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = [
        "*"
      ]
      principals {
        identifiers = var.iam_arns_to_grant_sns_kms_access_to
        type        = "AWS"
      }
    }
  }
}
