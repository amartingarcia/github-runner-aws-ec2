# GitHub Actions variable for AWS IAM Role to assume via OIDC
resource "github_actions_secret" "aws_role_to_assume_oidc" {
  repository      = var.github_repository
  secret_name     = "ROLE_TO_ASSUME"
  plaintext_value = aws_iam_role.github_oidc_ec2.arn

  depends_on = [local_file.github_ec2]
}
