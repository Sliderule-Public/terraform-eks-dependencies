output "ENVIRONMENT" {
  value = var.environment
}

output "SENTRY_ENVIRONMENT" {
  value = var.environment
}

output "SHIELDRULE_ENVIRONMENT" {
  value = var.environment
}

output "SERVER_BUCKET" {
  value = module.server_docs_bucket.bucket
}

output "REDIS_HOST" {
  value = module.redis.endpoint
}

output "REDIS_PORT" {
  value = 6379
}

output "SQS_QUEUE_NAME" {
  value = module.sqs.name
}

output "SQS_URL" {
  value = module.sqs.url
}

output "EKS_TASK_ROLE_ARN" {
  value = var.eks_task_role_arn == "" ? aws_iam_role.eks-tasks[0].arn : var.eks_task_role_arn
}
