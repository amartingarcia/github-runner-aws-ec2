# Create an OpenID Connect (OIDC) provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github_oidc_ec2" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # Thumbprint for GitHub's OIDC provider
}

# Create an IAM role for GitHub Actions OIDC with a trust policy
resource "aws_iam_role" "github_oidc_ec2" {
  name = "github_oidc_ec2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_oidc_ec2.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:${local.fullname_repository}:*",
          }
        }
      }
    ]
  })
}

# Create an IAM policy for the OIDC role
resource "aws_iam_policy" "github_oidc_ec2" {
  name        = "github_oidc_ec2_passrole"
  description = "Policy for GitHub OIDC to pass IAM roles"
  policy      = data.aws_iam_policy_document.github_oidc_ec2.json
}

# Attach the full EC2 access policy to the OIDC role
resource "aws_iam_role_policy_attachment" "github_oidc_ec2_ful" {
  role       = aws_iam_role.github_oidc_ec2.name
  policy_arn = data.aws_iam_policy.aws_ec2_full_access.arn
}

# Attach the custom OIDC policy to the OIDC role
resource "aws_iam_role_policy_attachment" "github_oidc_ec2" {
  role       = aws_iam_role.github_oidc_ec2.name
  policy_arn = aws_iam_policy.github_oidc_ec2.arn
}
