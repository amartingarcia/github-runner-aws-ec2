output "aws_instance_id" {
  description = "The ID of the AWS EC2 instance created for the GitHub deployment."
  value       = aws_instance.github_ec2.id
}

output "aws_ami_id" {
  description = "The ID of the AWS AMI (Amazon Machine Image) created from the GitHub EC2 instance."
  value       = aws_ami_from_instance.github_ec2.id
}

output "aws_instance_role" {
  description = "The name of the IAM instance profile associated with the AWS EC2 instance."
  value       = aws_iam_instance_profile.github_ec2.name
}

output "github_variables" {
  description = "A map of GitHub Actions variables including AWS AMI ID, subnet ID, security group ID, and role name."
  value = {
    AWS_AMI_ID            = github_actions_variable.aws_ami_id.value,
    AWS_SUBNET_ID         = github_actions_variable.aws_subnet_id.value,
    AWS_SECURITY_GROUP_ID = github_actions_variable.aws_security_group_id.value,
    AWS_ROLE_NAME         = github_actions_variable.aws_role_name.value,
  }
}
