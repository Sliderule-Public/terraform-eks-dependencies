data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_iam_role" "optional_role" {
  count = var.eks_task_role_name != "" ? 1 : 0
  name  = var.eks_task_role_name
}

locals {
  account_id                    = data.aws_caller_identity.current.account_id
  vpc_id                        = var.create_vpc == true ? module.shared_vpc[0].vpc_id : var.vpc_id
  public_subnet_ids             = var.create_vpc == true ? module.shared_vpc[0].public_subnet_ids : var.public_subnet_ids
  private_subnet_ids            = var.create_vpc == true ? module.shared_vpc[0].private_subnet_ids : var.private_subnet_ids
  database_az                   = var.create_vpc == true ? module.shared_vpc[0].az_1 : data.aws_availability_zones.available.names[0]
  module_release_tag            = 1.0
  optional_role_arn             = var.eks_task_role_name != "" ? data.aws_iam_role.optional_role[0].arn : ""
  task_role_to_grant_kms_access = var.eks_task_role_name != "" ? local.optional_role_arn : aws_iam_role.eks-tasks[0].arn
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }

    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.12.0"
    }

    auth0 = {
      source = "alexkappa/auth0"
    }
  }

  required_version = ">= 0.14.9"
}
