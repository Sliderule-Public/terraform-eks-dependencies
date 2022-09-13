<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_main"></a> [main](#module\_main) | ./eks-app | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarms_email_recipients"></a> [alarms\_email\_recipients](#input\_alarms\_email\_recipients) | list of emails to receive various alarms for this stack | `list(string)` | `[]` | no |
| <a name="input_api_eks_port"></a> [api\_eks\_port](#input\_api\_eks\_port) | used in helm to expose the API service through security group rules | `number` | `31257` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | used to build an SSH key name for the optional EKS node group. | `string` | `"shieldrule"` | no |
| <a name="input_app_vpc_cidr"></a> [app\_vpc\_cidr](#input\_app\_vpc\_cidr) | desired value for the VPC CIDR if create\_vpc is true. If create\_vpc is false, then the CIDR of the VPC being used in vpc\_id. | `string` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the AWS ACM certificate to use with optional EKS-made application load balancers. Only required if var.use\_scripts is true and you're using Sliderule-provided AWS EKS ALB functionality. | `string` | `""` | no |
| <a name="input_company_name"></a> [company\_name](#input\_company\_name) | used in resource naming | `string` | n/a | yes |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | if true, will create a new VPC to host resources in this stack. If false, vpc\_id, private\_subnet\_ids and public\_subnet\_ids are required | `bool` | `true` | no |
| <a name="input_database_instance_type"></a> [database\_instance\_type](#input\_database\_instance\_type) | n/a | `string` | `"db.t3.xlarge"` | no |
| <a name="input_database_security_group_additional_rules"></a> [database\_security\_group\_additional\_rules](#input\_database\_security\_group\_additional\_rules) | optional additional security group rules for the database security group. | <pre>list(object({<br>    description = string<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_block  = string<br>  }))</pre> | `[]` | no |
| <a name="input_deploy_eks"></a> [deploy\_eks](#input\_deploy\_eks) | if true, a new EKS cluster is created | `bool` | `true` | no |
| <a name="input_deploy_read_replica"></a> [deploy\_read\_replica](#input\_deploy\_read\_replica) | if true, deploys an optional read replica for the RDS instance | `bool` | `false` | no |
| <a name="input_docs_eks_port"></a> [docs\_eks\_port](#input\_docs\_eks\_port) | used in helm to expose the docs service through security group rules | `number` | `31256` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster to be used to create OIDC providers for IAM roles. Only required if deploy\_eks is false | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | used in resource naming and namespacing | `string` | n/a | yes |
| <a name="input_iam_arns_to_grant_sns_kms_access_to"></a> [iam\_arns\_to\_grant\_sns\_kms\_access\_to](#input\_iam\_arns\_to\_grant\_sns\_kms\_access\_to) | n/a | `list(string)` | `[]` | no |
| <a name="input_initial_database"></a> [initial\_database](#input\_initial\_database) | name of initial database in RDS | `string` | n/a | yes |
| <a name="input_kms_grantees"></a> [kms\_grantees](#input\_kms\_grantees) | ARNs of IAM users to allow decrypt and encrypt access to KMS keys | `list(string)` | `[]` | no |
| <a name="input_master_db_password"></a> [master\_db\_password](#input\_master\_db\_password) | password to user for master user in RDS | `string` | n/a | yes |
| <a name="input_master_db_username"></a> [master\_db\_username](#input\_master\_db\_username) | master db username to use for RDS | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | only needed if create\_vpc is false. Private subnets to use to host some private resources in this stack | `list(string)` | `[]` | no |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | only needed if create\_vpc is false. Public subnets to use to host some public resources in this stack | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | aws region to deploy into | `string` | n/a | yes |
| <a name="input_server_iam_role_policy_statements"></a> [server\_iam\_role\_policy\_statements](#input\_server\_iam\_role\_policy\_statements) | optional additional IAM policies to apply to the IAM role assigned to the EKS tasks | <pre>list(object({<br>    effect    = string<br>    actions   = list(string)<br>    resources = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_services_to_grant_kms_access_to"></a> [services\_to\_grant\_kms\_access\_to](#input\_services\_to\_grant\_kms\_access\_to) | list of additional AWS services to permit for encrypting / decrypting the KMS keys in this stack | `list(string)` | `[]` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | if true, will skip the final snapshot if the RDS instance is deleted | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | optional snapshot to use to create RDS instance | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | optional AWS tags to apply to most resources deployed with this stack | `any` | `{}` | no |
| <a name="input_use_only_private_subnets"></a> [use\_only\_private\_subnets](#input\_use\_only\_private\_subnets) | If true, will use only private subnets to provision all network-dependant resources | `bool` | `false` | no |
| <a name="input_use_variable_scripts"></a> [use\_variable\_scripts](#input\_use\_variable\_scripts) | if true, null\_resource resources will be used to run scripts that generate var files for kubernetes/aws/shieldrule | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | only needed if create\_vpc is false. VPC to use to host resources in this stack | `string` | `""` | no |
| <a name="input_web_eks_port"></a> [web\_eks\_port](#input\_web\_eks\_port) | used in helm to expose the web service through security group rules | `number` | `31255` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->