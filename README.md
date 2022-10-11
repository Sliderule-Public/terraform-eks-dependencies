# EKS Terraform Module

## Details
This module creates all resources needed to host the Sliderule app in AWS EKS.

## Creating a new environment
This example includes a module call with only required variables. Refer to the [variables readme](/variables.md) for a list of all possible variables.
#### Prerequisites
- add an AWS Secrets Manager secret with the name `sliderule/{environment}/database` and values for `username` and `password` in the same AWS account and region that's you're deploying this stack to

#### Sample
```terraform
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

module "test" {
  source       = "github.com/Modern-Logic/terraform-eks.git"
  company_name = "my_company_name"
  environment = "my_environment"
  region = "my_aws_region"
  app_vpc_cidr = "my_vpc_cidr"
  initial_database = "my_initial_database_name"
}
```
