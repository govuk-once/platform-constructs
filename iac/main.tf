provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "name_prefix" {
  description = "Prefix for the CodeArtifact domain and repository names"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the customer-managed KMS key"
  type        = string
}

variable "additional_accounts" {
  description = "List of additional AWS account IDs to grant read access, eg [\"123456789012\", \"234567890123\"]"
  type        = list(string)
}

variable "push_roles_arns" {
  description = "List of IAM role ARNs that will have push access"
  type        = list(string)
  default     = []
}

resource "aws_kms_key_policy" "codeartifact_kms_policy" {
  key_id = var.kms_key_arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = ["*"]
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:Re_encrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_codeartifact_domain" "this" {
  domain         = "${var.name_prefix}-domain"
  encryption_key = aws_kms_key_policy.codeartifact_kms_policy.key_id
}

resource "aws_codeartifact_repository" "this" {
  domain       = aws_codeartifact_domain.this.domain
  repository   = "${var.name_prefix}-repo"
  description  = "GDS Once ${var.name_prefix} NPM Repository"

  external_connections {
    external_connection_name = "public:npmjs"
  }

  permissions_policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "codeartifact:ReadFromRepository",
        Resource = aws_codeartifact_repository.this.arn,
        Principal = {
          AWS = [for account in var.additional_accounts: "arn:aws:iam::${account}:root"]
        }
      },
      {
        Effect   = "Allow",
        Action   = "codeartifact:WriteToRepository",
        Resource = aws_codeartifact_repository.this.arn,
        Principal = {
          AWS = var.push_roles_arns
        }
      }
    ]
  })
}

resource "aws_iam_policy" "codeartifact_pull_access_policy" {
  name = "${var.name_prefix}-pull-access-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "codeartifact:DescribeDomain",
          "codeartifact:GetAuthorizationToken",
          "codeartifact:GetRepositoryEndpoint",
          "codeartifact:ReadFromRepository"
        ],
        Resource = aws_codeartifact_domain.this.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_pull_access_policy_to_additional_accounts" {
  count = length(var.additional_accounts)

  role       = format("arn:aws:iam::%s:role/CodeArtifactPullAccessRole", var.additional_accounts[count.index])
  policy_arn = aws_iam_policy.codeartifact_pull_access_policy.arn
}

output "codeartifact_repo_arn" {
  value = aws_iam_policy.codeartifact_pull_access_policy.arn
}