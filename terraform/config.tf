terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.2.3"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

  default_tags {
    tags = {
      repository = var.github_repository
    }
  }
}

provider "github" {
  token = var.github_token
}
