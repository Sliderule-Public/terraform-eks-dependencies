module "rds_role" {
  environment  = var.environment
  company_name = var.company_name
  region       = var.region
  tags         = var.tags
  source       = "github.com/Modern-Logic/terraform-modules.git//simple/iam_role?ref=v1.13.0"
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

  dynamic statement {
    for_each = var.deploy_s3_buckets ? [1] : []
    content {
      effect    = "Allow"
      actions   = ["s3:*"]
      resources = [
        "${module.server_docs_bucket[0].bucket_arn}/*",
        module.server_docs_bucket[0].bucket_arn
      ]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeTags", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "eks-tasks" {
  count = var.eks_task_role_name == "" ? 1 : 0
  name  = "${var.company_name}-${var.environment}-${var.region}-app-eks-tasks"

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
    name   = "eks-${var.environment}-${var.region}-tasks"
    policy = data.aws_iam_policy_document.eks_task.json
  }
}

resource "aws_iam_policy" "optional_role_policy" {
  count  = var.eks_task_role_name != "" ? 1 : 0
  name   = "${var.company_name}-${var.environment}-${var.region}-eks-tasks"
  policy = data.aws_iam_policy_document.eks_task.json
}

resource "aws_iam_role_policy_attachment" "optional_role_attachment" {
  count      = var.eks_task_role_name != "" ? 1 : 0
  role       = var.eks_task_role_name
  policy_arn = aws_iam_policy.optional_role_policy[0].arn
}