data "aws_iam_policy_document" "eks_task_cross_account" {
  provider = aws.cross_region_replication
  count    = var.deploy_cross_region_bucket && var.deploy_s3_buckets ? 1 : 0
  dynamic statement {
    for_each = var.deploy_s3_buckets ? [1] : []
    content {
      effect    = "Allow"
      actions   = ["s3:*"]
      resources = [
        "${module.server_docs_bucket[0].crr_bucket_arn}/*",
        module.server_docs_bucket[0].crr_bucket_arn
      ]
    }
  }
}

resource "aws_iam_policy" "eks_task_cross_account" {
  provider = aws.cross_region_replication
  count    = var.deploy_cross_region_bucket && var.deploy_s3_buckets ? 1 : 0
  name     = "${var.company_name}-${var.environment}-${var.region}-eks-tasks-cross-account"
  policy   = data.aws_iam_policy_document.eks_task_cross_account[0].json
}

resource "aws_iam_role_policy_attachment" "eks_task_cross_account" {
  provider   = aws.cross_region_replication
  count      = var.deploy_cross_region_bucket && var.deploy_s3_buckets ? 1 : 0
  role       = var.cross_region_task_role_name
  policy_arn = aws_iam_policy.eks_task_cross_account[0].arn
}