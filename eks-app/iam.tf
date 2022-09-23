module "rds_role" {
  environment  = var.environment
  company_name = var.company_name
  tags         = var.tags
  source       = "git@github.com:Modern-Logic/terraform-modules.git//simple/iam_role"
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
