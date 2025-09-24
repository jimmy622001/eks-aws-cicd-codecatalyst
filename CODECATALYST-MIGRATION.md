# Migration from CodeCommit/GitHub to CodeCatalyst

This guide explains how to migrate from the previous CodeCommit/GitHub + CodePipeline setup to Amazon CodeCatalyst.

## What Changed

### Before (CodeCommit/GitHub + CodePipeline)
- Used GitHub repositories with CodeStar connections
- CodePipeline for orchestration
- CodeBuild for build/deploy

### After (CodeCatalyst)
- CodeCatalyst spaces and projects
- CodeCatalyst workflows (replaces CodePipeline)
- CodeCatalyst dev environments
- Integrated with existing CodeBuild

## Prerequisites

1. **CodeCatalyst Space**: Create a CodeCatalyst space in the AWS Console
2. **CodeCatalyst Project**: Create a project within your space
3. **Repository**: Create or import your repository into CodeCatalyst

## Setup Steps

### 1. Create CodeCatalyst Resources

1. Go to [CodeCatalyst Console](https://codecatalyst.aws/)
2. Create a new Space (if you don't have one)
3. Create a new Project within the space
4. Create or import your repository

### 2. Update Terraform Variables

Update your `terraform.tfvars` files with CodeCatalyst configuration:

```hcl
# Replace GitHub variables with CodeCatalyst
codecatalyst_space_name    = "your-space-name"
codecatalyst_project_name  = "your-project-name"
repository_name           = "your-repo-name"
branch_name              = "main"

# Dev environment settings
dev_environment_instance_type = "dev.standard1.medium"
inactivity_timeout_minutes = 15
storage_size = 16
```

### 3. Deploy Updated Infrastructure

```bash
# Plan the changes
terraform plan -var-file=workspaces/dev/dev.tfvars -var-file=workspaces/dev/cicd.tfvars

# Apply the changes
terraform apply -var-file=workspaces/dev/dev.tfvars -var-file=workspaces/dev/cicd.tfvars
```

### 4. Set Up CodeCatalyst Workflow

1. Copy the workflow template to your repository:
   ```bash
   mkdir -p .codecatalyst/workflows
   cp modules/cicd-pipeline/templates/codecatalyst-workflow.yml .codecatalyst/workflows/
   ```

2. Customize the workflow file for your specific needs

3. Commit and push to trigger the workflow

## Key Differences

### Variables Changed
- `github_repository` → `codecatalyst_space_name`, `codecatalyst_project_name`, `repository_name`
- Added `dev_environment_instance_type`, `inactivity_timeout_minutes`, `storage_size`

### Resources Changed
- `aws_codestarconnections_connection` → `aws_codecatalyst_dev_environment`
- `aws_codepipeline` → CodeCatalyst workflows (YAML-based)
- IAM roles updated for CodeCatalyst permissions

### Outputs Changed
- `pipeline_name` → `dev_environment_id`
- `github_connection_arn` → `codecatalyst_space_name`, `codecatalyst_project_name`

## Benefits of CodeCatalyst

1. **Integrated Development**: Dev environments with VS Code in the browser
2. **Simplified Workflows**: YAML-based workflow definitions
3. **Better Collaboration**: Built-in project management features
4. **Cost Optimization**: Pay-per-use model for dev environments
5. **AWS Native**: Deeper integration with AWS services

## Troubleshooting

### Common Issues

1. **Space/Project Not Found**: Ensure the space and project exist in CodeCatalyst
2. **Permission Issues**: Verify IAM roles have CodeCatalyst permissions
3. **Workflow Failures**: Check the workflow YAML syntax and environment configuration

### Rollback Plan

If you need to rollback to the previous setup:

1. Revert the Terraform configuration files
2. Update variables back to GitHub configuration
3. Re-apply Terraform with the old configuration

## Next Steps

1. Set up CodeCatalyst workflows for your specific deployment needs
2. Configure dev environments for your team
3. Explore CodeCatalyst's project management features
4. Set up notifications and monitoring for workflows