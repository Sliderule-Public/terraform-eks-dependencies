module "rds_role" {
  environment  = var.environment
  company_name = var.company_name
  tags         = var.tags
  source       = "github.com/Modern-Logic/terraform-modules.git//simple/iam_role?ref=v1.0"
  role_name    = "rds"
  service      = "rds.amazonaws.com"
  policy       = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroups"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

data "aws_iam_policy_document" "eks_task" {
  dynamic "statement" {
    for_each = var.server_iam_role_policy_statements
    content {
      effect    = statement.value["effect"]
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
    }
  }

  // Allow role to publish to SQS
  statement {
    effect    = "Allow"
    actions   = ["sqs:*"]
    resources = [module.sqs.arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = [
      "${module.server_docs_bucket.bucket_arn}/*",
      module.server_docs_bucket.bucket_arn
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeTags", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "eks-tasks" {
  count = var.eks_task_role_arn == "" ? 1 : 0
  name  = "${var.company_name}-${var.environment}-app-eks-tasks"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  inline_policy {
    name   = "eks-${var.environment}-tasks"
    policy = data.aws_iam_policy_document.eks_task.json
  }
}
