# Data source
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_iam_policy" "aws_ec2_readonly_access" {
  name = "AmazonEC2ReadOnlyAccess"
}

data "aws_iam_policy" "aws_ec2_full_access" {
  name = "AmazonEC2FullAccess"
}

data "aws_iam_policy_document" "github_ec2" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "github_oidc_ec2" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
  }
}
