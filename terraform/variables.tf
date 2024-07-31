variable "region" {
  description = "The AWS region where resources will be deployed."
  type        = string
}

variable "access_key" {
  description = "The AWS Access Key used for authentication."
  type        = string
}

variable "secret_key" {
  description = "The AWS Secret Key used for authentication."
  type        = string
}

variable "github_token" {
  description = "The GitHub token used for accessing the repository."
  type        = string
}

variable "github_organization" {
  description = "The GitHub organization that owns the repository."
  type        = string
}

variable "github_repository" {
  description = "The GitHub repository name where the source code is stored."
  type        = string
}

variable "aws_access_key_id" {
  description = "The AWS Access Key ID for programmatic access. Leave empty to use the default AWS credentials provider chain."
  type        = string
  default     = ""
}

variable "aws_secret_access_key" {
  description = "The AWS Secret Access Key for programmatic access. Leave empty to use the default AWS credentials provider chain."
  type        = string
  default     = ""
}

variable "aws_subnet_id" {
  description = "The ID of the AWS subnet where resources will be deployed."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the AWS VPC where resources will be deployed."
  type        = string
}
