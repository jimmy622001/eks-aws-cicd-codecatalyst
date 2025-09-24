# IAM Role for CodeCatalyst
resource "aws_iam_role" "codecatalyst_role" {
  name = "${var.cluster_name}-codecatalyst-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codecatalyst.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for CodeCatalyst
resource "aws_iam_role_policy" "codecatalyst_policy" {
  name = "${var.cluster_name}-codecatalyst-policy"
  role = aws_iam_role.codecatalyst_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObjectAcl",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.artifacts.arn,
          "${aws_s3_bucket.artifacts.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codecatalyst:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# S3 Bucket for CodeCatalyst Artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.cluster_name}-codecatalyst-artifacts-${data.aws_caller_identity.current.account_id}"

  tags = var.tags
}

resource "aws_s3_bucket_acl" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "cleanup"
    status = "Enabled"

    # Required filter - empty filter means apply to all objects
    filter {}

    expiration {
      days = 30
    }
  }
}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "${var.cluster_name}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for CodeBuild
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.cluster_name}-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.artifacts.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterfacePermission"
        ]
        Resource = [
          "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:network-interface/*"
        ]

        # The above will still show a deprecation warning but is the current recommended approach
        # The warning is a false positive in this case as we're not using the deprecated attribute directly
      },
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole"
        ]
        Resource = ["*"]
      }
    ]
  })
}

# CodeBuild Project
resource "aws_codebuild_project" "build" {
  name          = "${var.cluster_name}-build"
  description   = "Build project for ${var.cluster_name}"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.artifacts.bucket
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "CLUSTER_NAME"
      value = var.cluster_name
    }

    environment_variable {
      name  = "AWS_REGION"
      value = data.aws_region.current.name
    }
  }

  source {
    type     = "CODECOMMIT"
    location = "https://git-codecommit.${data.aws_region.current.name}.amazonaws.com/v1/repos/${var.repository_name}"
    buildspec = templatefile("${path.module}/templates/buildspec.yml.tpl", {
      cluster_name = var.cluster_name
      aws_region   = data.aws_region.current.name
    })
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${var.cluster_name}-build"
    }
  }

  tags = var.tags
}

# CodeCatalyst Dev Environment
resource "aws_codecatalyst_dev_environment" "main" {
  space_name   = var.codecatalyst_space_name
  project_name = var.codecatalyst_project_name

  alias = "${var.cluster_name}-dev-env"
  ides {
    name = "VSCode"
  }

  instance_type              = var.dev_environment_instance_type
  inactivity_timeout_minutes = var.inactivity_timeout_minutes

  persistent_storage {
    size = var.storage_size
  }

  repositories {
    repository_name = var.repository_name
    branch_name     = var.branch_name
  }
}

# Note: Cost optimization using Lambda functions has been moved to a separate module
# to better manage dependencies and permissions. Please see the cost-optimization module
# for implementing resource scheduling.

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}
