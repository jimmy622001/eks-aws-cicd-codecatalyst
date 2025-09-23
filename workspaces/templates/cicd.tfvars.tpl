# CI/CD Configuration for ${environment} Environment

# GitHub Repository Configuration
github_repository = "jimmy622001/eks-aws-cicd"  # GitHub repository in format "username/repo"
branch_name       = "main"

# Build Configuration
build_compute_type = "BUILD_GENERAL1_MEDIUM"

# Cost Optimization
enable_cost_optimization = true

# Notification Settings
slack_webhook_url  = ""  # Optional: Add your Slack webhook URL for notifications
notification_email = ""  # Optional: Add your email for notifications

# Environment-specific overrides
# Add any environment-specific overrides here
