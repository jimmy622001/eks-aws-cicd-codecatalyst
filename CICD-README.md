# AWS Native CI/CD Pipeline for EKS

This document describes the AWS-native CI/CD pipeline that replaces the previous Jenkins-based solution. The new pipeline uses AWS CodePipeline, CodeBuild, and CodeDeploy to provide a fully managed CI/CD solution.

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   GitHub Repo   │───▶│  CodePipeline    │───▶│  CodeBuild      │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         ▲                      │                        │
         │                      │                        ▼
         │                      │                ┌─────────────────┐
         │                      └──────────────▶│  CodeDeploy     │
         │                                       └─────────────────┘
         │                                               │
         │                                               ▼
         │                                       ┌─────────────────┐
         └───────────────────────────────────────│  EKS Cluster   │
                                                 └─────────────────┘
```

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **GitHub Repository** with your application code
3. **AWS CLI** configured with appropriate credentials
4. **kubectl** configured to access your EKS cluster

## Setup Instructions

### 1. Create a GitHub Personal Access Token

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate a new token with the following scopes:
   - `repo` (Full control of private repositories)
   - `admin:repo_hook` (if you want to automatically create webhooks)

### 2. Configure AWS CodeStar Connection

1. Go to AWS CodePipeline → Settings → Connections
2. Create a new connection to GitHub
3. Follow the prompts to authenticate with GitHub
4. Note the connection ARN (you'll need this for the Terraform variables)

### 3. Configure Terraform Variables

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Update the variables in `terraform.tfvars` with your values:
   ```hcl
   # Required
   github_repository = "your-username/your-repo"
   
   # Optional
   branch_name             = "main"
   build_compute_type      = "BUILD_GENERAL1_MEDIUM"
   enable_cost_optimization = true
   ```

### 4. Deploy the Pipeline

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the planned changes:
   ```bash
   terraform plan
   ```

3. Apply the changes:
   ```bash
   terraform apply
   ```

## Pipeline Stages

1. **Source**: Pulls code from your GitHub repository
2. **Build**: Builds and tests your application using CodeBuild
   - Installs dependencies
   - Runs tests
   - Builds container images (if applicable)
   - Pushes artifacts to S3
3. **Deploy**: Deploys your application to EKS
   - Updates Kubernetes manifests
   - Applies changes using kubectl
   - Verifies deployment

## Cost Optimization

The pipeline includes several cost optimization features:

- **Spot Instances**: CodeBuild can use Spot Instances for build jobs
- **Auto-scaling**: Resources scale based on demand
- **Cleanup Policies**: Old artifacts are automatically cleaned up
- **Scheduled Shutdown**: Non-production resources can be automatically stopped during off-hours

## Monitoring and Logging

- **CodePipeline**: View pipeline execution history and status
- **CodeBuild**: View build logs and metrics in AWS Console
- **CloudWatch**: Set up alarms and dashboards for monitoring

## Troubleshooting

### GitHub Connection Issues
- Ensure the GitHub token has the correct permissions
- Check the AWS CodeStar connection status in the AWS Console
- Verify the repository URL and branch name in the pipeline configuration

### Build Failures
- Check the CodeBuild logs for detailed error messages
- Verify that the buildspec.yml file is correctly configured
- Ensure all required environment variables are set

### Deployment Issues
- Check the EKS cluster status and node health
- Verify that the IAM roles have the necessary permissions
- Check the Kubernetes events for any deployment issues

## Cleanup

To remove all resources created by this pipeline:

```bash
terraform destroy
```

## Security Considerations

- Store sensitive information (tokens, passwords) in AWS Secrets Manager or Parameter Store
- Use IAM roles with least privilege
- Enable encryption for all stored artifacts
- Regularly rotate access tokens and credentials
