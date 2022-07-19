variable "doormat_iam_principal" {
  description = "From the doormat documentation. https://docs.prod.secops.hashicorp.services/doormat/tf_provider/"
  type        = string
}

variable "my_iam_principal" {
  description = "Refer to https://docs.prod.secops.hashicorp.services/doormat/tf_provider/"
  type        = string
}

variable "org" {
  description = "Your terraform cloud organization name."
  type        = string
}

variable "owner" {
  description = "Your name here, this is used to tag resources."
  type        = string
}

variable "purpose" {
  type    = string
  default = "Demo HashiStack"
}

variable "region" {
  description = "The region where the resources are created."
  default     = "us-west-2"
}

variable "se-region" {
  description = "Your region assignment here, this is used to tag resources. NOT cloud region"
  type        = string
  default     = null
}

variable "terraform" {
  type    = string
  default = "true"
}

variable "tfc_workspaces" {
  description = "List of workspaces to enable doormat provider."
  type        = list(string)
}

variable "ttl" {
  type    = string
  default = "-1"
}

locals {
  common_tags = {
    owner     = var.owner
    purpose   = var.purpose
    se-region = var.se-region
    terraform = var.terraform
    ttl       = var.ttl
  }
}
