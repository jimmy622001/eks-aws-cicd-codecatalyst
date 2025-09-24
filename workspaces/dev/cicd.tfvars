# CodeCatalyst Configuration for Development Environment

codecatalyst_space_name       = "eks-dev-space"
codecatalyst_project_name     = "eks-aws-cicd-dev"
repository_name               = "eks-aws-cicd"
branch_name                   = "develop"
build_compute_type            = "BUILD_GENERAL1_MEDIUM"
enable_cost_optimization      = true
dev_environment_instance_type = "dev.standard1.medium"
inactivity_timeout_minutes    = 15
storage_size                  = 16

# Optional: Add notification settings
# slack_webhook_url  = "https://hooks.slack.com/..."
# notification_email = "dev-team@example.com"
