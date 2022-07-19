output "role_arn_base" {
  description = "Terraform IAM role base"
  value       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.owner}-tfc-"
}
