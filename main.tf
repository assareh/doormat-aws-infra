locals {
  common_tags = {
    owner     = "assareh"
    purpose   = "Demo Terraform and Vault"
    se-region = "AMER - West E2 - R2"
    terraform = "true" # true/false
    ttl       = "-1"   #hours
  }
}

variable "my_iam_principal" {}

provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = local.common_tags
  }
}

### For Packer ###
resource "aws_iam_role" "packer_role" {
  name = "assareh-hashidemos-packer-role"

  assume_role_policy = data.aws_iam_policy_document.packer_assume_role_policy_definition.json
}

data "aws_iam_policy_document" "packer_assume_role_policy_definition" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = [var.my_iam_principal]
      type        = "AWS"
    }
  }
}

resource "aws_iam_policy" "packer_policy_definition" {
  name = "assareh-hashidemos-packer-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
{
  "Sid": "PackerIAMPassRole",
  "Effect": "Allow",
  "Action": ["iam:PassRole", "iam:GetInstanceProfile"],
  "Resource": ["*"]
},
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CopyImage",
        "ec2:CreateImage",
        "ec2:CreateKeypair",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteKeyPair",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSnapshot",
        "ec2:DeleteVolume",
        "ec2:DeregisterImage",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeImages",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeRegions",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:GetPasswordData",
        "ec2:ModifyImageAttribute",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifySnapshotAttribute",
        "ec2:RegisterImage",
        "ec2:RunInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances",
        "sts:SetSourceIdentity"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "packer" {
  name       = "assareh-hashidemos-packer"
  roles      = [aws_iam_role.packer_role.name]
  policy_arn = aws_iam_policy.packer_policy_definition.arn
}