# CodeCatalyst Configuration for Production Environment

codecatalyst_space_name       = "eks-prod-space"
codecatalyst_project_name     = "eks-aws-cicd-prod"
repository_name               = "eks-aws-cicd"
branch_name                   = "main"
build_compute_type            = "BUILD_GENERAL1_LARGE"
enable_cost_optimization      = true
dev_environment_instance_type = "dev.standard1.large"
inactivity_timeout_minutes    = 30
storage_size                  = 32

# Optional: Add notification settings
# slack_webhook_url  = "https://hooks.slack.com/..."
# notification_email = "prod-team@example.com"
