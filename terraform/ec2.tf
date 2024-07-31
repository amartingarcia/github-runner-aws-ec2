# Create a user for the GitHub EC2 instance
resource "aws_iam_user" "github_ec2" {
  name = "github_ec2"
  path = "/"
}

# Create access and secret key for the user
resource "aws_iam_access_key" "github_ec2" {
  user = aws_iam_user.github_ec2.name

  lifecycle {
    ignore_changes = []
  }
}

# Export access and secret key to a local file
resource "local_file" "github_ec2" {
  content  = <<EOT
aws_access_key_id = "${aws_iam_access_key.github_ec2.id}"
aws_secret_access_key = "${aws_iam_access_key.github_ec2.secret}"
EOT
  filename = "${path.module}/aws_credentials.auto.tfvars"
}

# Create a policy for the user with necessary permissions
resource "aws_iam_policy" "github_ec2" {
  name        = "github-runner-policy-ec2"
  path        = "/"
  description = "Policy for GitHub EC2 runner"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:ReplaceIamInstanceProfileAssociation",
          "ec2:AssociateIamInstanceProfile"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "iam:PassRole",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateTags"
        ],
        Resource = "*",
        Condition = {
          StringEquals = {
            "ec2:CreateAction" = "RunInstances"
          }
        }
      }
    ]
  })
}

# Attach the policy to the user
resource "aws_iam_user_policy_attachment" "github_ec2" {
  user       = aws_iam_user.github_ec2.name
  policy_arn = aws_iam_policy.github_ec2.arn
}

# Create an EC2 instance for the GitHub runner
resource "aws_instance" "github_ec2" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"

  user_data = <<-EOL
  #!/bin/bash -xe

  sudo yum update -y && \
  sudo yum install docker -y && \
  sudo yum install git -y && \
  sudo yum install libicu -y && \
  sudo systemctl enable docker
  EOL

  lifecycle {
    ignore_changes = []
  }

  tags = {
    name = "github-ec2"
  }
}

# Wait for the EC2 instance to reach the running state
resource "null_resource" "wait_for_instance" {
  provisioner "local-exec" {
    command = "while true; do status=$(aws ec2 describe-instances --instance-ids ${aws_instance.github_ec2.id} --query 'Reservations[*].Instances[*].State.Name' --output text); if [ \"$status\" = \"running\" ]; then break; fi; sleep 10; done"
  }
  depends_on = [aws_instance.github_ec2]
}

# Create an AMI from the running instance for reuse in workflows
resource "aws_ami_from_instance" "github_ec2" {
  name               = "github-ec2"
  source_instance_id = aws_instance.github_ec2.id

  depends_on = [null_resource.wait_for_instance]
}

# Terminate the running EC2 instance
resource "null_resource" "terminate_instance" {
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.github_ec2.id}"
  }
  depends_on = [aws_ami_from_instance.github_ec2]
}

# Create an instance profile for the EC2 instance
resource "aws_iam_instance_profile" "github_ec2" {
  name = "github_ec2"
  role = aws_iam_role.github_ec2.name
}

# Create an IAM role with a trust policy for the EC2 instance
resource "aws_iam_role" "github_ec2" {
  name               = "github_ec2"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.github_ec2.json
}

# Attach a policy to the IAM role
resource "aws_iam_role_policy_attachment" "github_ec2" {
  role       = aws_iam_role.github_ec2.name
  policy_arn = data.aws_iam_policy.aws_ec2_readonly_access.arn
}

# Create a Security Group for the EC2 instance
resource "aws_security_group" "github_ec2" {
  name   = "github-ec2"
  vpc_id = var.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "github-ec2"
  }
}
