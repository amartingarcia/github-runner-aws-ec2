# GitHub Actions secret for AWS Access Key ID
resource "github_actions_secret" "aws_access_key_id" {
  repository      = var.github_repository
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key_id

  depends_on = [local_file.github_ec2]
}

# GitHub Actions secret for AWS Secret Access Key
resource "github_actions_secret" "aws_secret_access_key" {
  repository      = var.github_repository
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_access_key

  depends_on = [local_file.github_ec2]
}

# GitHub Actions secret for AWS Region
resource "github_actions_secret" "aws_region" {
  repository      = var.github_repository
  secret_name     = "AWS_REGION"
  plaintext_value = var.region

  depends_on = [local_file.github_ec2]
}

# GitHub Actions secret for GitHub Personal Access Token
resource "github_actions_secret" "github_pat" {
  repository      = var.github_repository
  secret_name     = "GH_PERSONAL_ACCESS_TOKEN"
  plaintext_value = var.github_token

  depends_on = [local_file.github_ec2]
}

# GitHub Actions variable for default AWS region
resource "github_actions_variable" "aws_default_region" {
  repository    = var.github_repository
  variable_name = "AWS_DEFAULT_REGION"
  value         = var.region

  depends_on = [local_file.github_ec2]
}

# GitHub Actions variable for AWS region
resource "github_actions_variable" "aws_region" {
  repository    = var.github_repository
  variable_name = "AWS_REGION"
  value         = var.region

  depends_on = [local_file.github_ec2]
}

# GitHub Actions variable for AWS Access Key ID
resource "github_actions_variable" "aws_access_key_id" {
  repository    = var.github_repository
  variable_name = "AWS_ACCESS_KEY_ID"
  value         = var.aws_access_key_id

  depends_on = [local_file.github_ec2]
}

# GitHub Actions variable for AWS Secret Access Key
resource "github_actions_variable" "aws_secret_access_key" {
  repository    = var.github_repository
  variable_name = "AWS_SECRET_ACCESS_KEY"
  value         = var.aws_secret_access_key

  depends_on = [local_file.github_ec2]
}

# GitHub Actions variable for AWS AMI ID
resource "github_actions_variable" "aws_ami_id" {
  repository    = var.github_repository
  variable_name = "AWS_AMI_ID"
  value         = aws_ami_from_instance.github_ec2.id

  depends_on = [local_file.github_ec2]
}

# GitHub Actions variable for AWS Subnet ID
resource "github_actions_variable" "aws_subnet_id" {
  repository    = var.github_repository
  variable_name = "AWS_SUBNET_ID"
  value         = var.aws_subnet_id

  depends_on = [local_file.github_ec2]
}

# GitHub Actions variable for AWS Security Group ID
resource "github_actions_variable" "aws_security_group_id" {
  repository    = var.github_repository
  variable_name = "AWS_SECURITY_GROUP_ID"
  value         = aws_security_group.github_ec2.id

  depends_on = [local_file.github_ec2]
}

# GitHub Actions variable for AWS Role Name
resource "github_actions_variable" "aws_role_name" {
  repository    = var.github_repository
  variable_name = "AWS_ROLE_NAME"
  value         = aws_iam_instance_profile.github_ec2.name

  depends_on = [local_file.github_ec2]
}
