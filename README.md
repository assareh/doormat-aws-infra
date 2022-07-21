# doormat-aws-infra

This repo creates an IAM role to be used for terraforming, and publishes the role ARN as an output for other workspaces to read.

Here's how I use this in a consumer workspace:

1. Give it a `TFE_TOKEN` environment variable. I use a variable set with a doormat team API token, and the doormat team has read outputs permission on this workspace.
2. Add the following code to your terraform configuration:
```
variable "TFC_WORKSPACE_NAME" {
  type    = string
  default = "" # An error occurs when you are running TF backend other than Terraform Cloud
}

data "tfe_outputs" "doormat_role" {
  organization = "hashidemos"
  workspace    = "doormat-aws-infra"
}

provider "doormat" {}

data "doormat_aws_credentials" "creds" {
  provider = doormat

  role_arn = "${data.tfe_outputs.doormat_role.values.role_arn_base}${var.TFC_WORKSPACE_NAME}"
}

terraform {
  required_providers {
    doormat = {
      source  = "doormat.hashicorp.services/hashicorp-security/doormat"
      version = "~> 0.0.2"
    }
  }
}
```