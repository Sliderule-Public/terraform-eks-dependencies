provider "aws" {
  region = var.region
}
provider "aws" {
  region = var.cross_region_replication_region
  alias  = "cross_region_replication"
}

variables {
  company_name                     = "crr-test"
  environment                      = "active"
  region                           = "us-east-1"
  app_vpc_cidr                     = "10.240.0.0/16"
  cross_region_vpc_cidr            = "10.241.0.0/16"
  initial_database                 = "cooldatabase"
  use_only_private_subnets         = true
  create_vpc                       = true
  cross_region_private_subnet_ids  = ["subnet-075c7af998b30cbfc", "subnet-095524e820b1019e8"]
  deploy_database                  = true
  deploy_cross_region_read_replica = true
  cross_region_replication_region  = "us-east-2"
}

run "sqs_queue_name" {
  command = plan
  assert {
    condition     = module.sqs.queue.name == "crr-test-active-sls"
    error_message = "SQS queue name is not correct"
  }
}

run "sns_topic_name" {
  command = plan
  assert {
    condition     = aws_sns_topic.alarms.name == "crr-test-active-alarms"
    error_message = "SNS topic name is not correct"
  }
}

run "server_docs_bucket_name" {
  command = plan
  assert {
    condition     = module.server_docs_bucket.bucket.bucket == "crr-test-active-us-east-1-server-documents"
    error_message = "S3 infrastructure bucket name is not correct"
  }
}

run "infrastructure_bucket_name" {
  command = plan
  assert {
    condition     = module.infrastructure_bucket.bucket.bucket == "crr-test-active-us-east-1-infrastructure-eks"
    error_message = "S3 server docs bucket name is not correct"
  }
}

run "redis_replication_group_engine" {
  command = plan
  assert {
    condition     = module.redis.redis.node_type == var.redis_node_type
    error_message = "Redis engine is not correct"
  }
}

run "redis_replication_group_at_rest_encryption_enabled" {
  command = plan
  assert {
    condition     = module.redis.redis.at_rest_encryption_enabled == true
    error_message = "Redis at rest encryption is not enabled"
  }
}

run "vpc_cross_region_cidr" {
  command = plan
  assert {
    condition     = module.shared_vpc_cross_region[0].vpc.cidr_block == var.cross_region_vpc_cidr
    error_message = "VPC cross region cidr is not correct"
  }
}

run "vpc_enable_dns_hostnames" {
  command = plan
  assert {
    condition     = module.shared_vpc[0].vpc.enable_dns_hostnames == true
    error_message = "VPC DNS hostnames are not enabled"
  }
}

run "vpc_enable_dns_support" {
  command = plan
  assert {
    condition     = module.shared_vpc[0].vpc.enable_dns_support == true
    error_message = "VPC DNS support is not enabled"
  }
}

run "vpc_cidr" {
  command = plan
  assert {
    condition     = module.shared_vpc[0].vpc.cidr_block == var.app_vpc_cidr
    error_message = "VPC cidr is not correct"
  }
}

run "sns_key_alias" {
  command = plan
  assert {
    condition     = module.sns_key.key_alias == "alias/crr-test-active-us-east-1-sns-key"
    error_message = "SNS KMS key alias is not correct"
  }
}

run "rds_key_alias_cross_region" {

  command = plan
  assert {
    condition     = module.rds_key_cross_region[0].key_alias == "alias/crr-test-active-us-east-1-rds-key"
    error_message = "RDS Cross Region KMS key alias is not correct"
  }
}

run "rds_key_alias" {
  command = plan
  assert {
    condition     = module.rds_key.key_alias == "alias/crr-test-active-us-east-1-rds-key"
    error_message = "RDS KMS key alias is not correct"
  }
}

run "main_key_alias_cross_region" {

  command = plan
  assert {
    condition     = module.main_key_cross_region[0].key_alias == "alias/crr-test-active-us-east-1-main-key-cross-region"
    error_message = "Main Cross Region KMS key alias is not correct"
  }
}

run "main_key_alias" {
  command = plan
  assert {
    condition     = module.main_key.key_alias == "alias/crr-test-active-us-east-1-main-key"
    error_message = "Main KMS key alias is not correct"
  }
}

run "rds_deletion_protection" {
  command = plan
  assert {
    condition     = module.rds_instance[0].rds_deletion_protection == true
    error_message = "RDS Deletion protection not enabled"
  }
}

run "rds_iam_role_name" {
  command = plan
  assert {
    condition     = module.rds_role.role_name == "crr-test-active-us-east-1-rds"
    error_message = "RDS IAM role name is not correct"
  }
}