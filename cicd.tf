# AWS CI/CD Pipeline
module "cicd_pipeline" {
  source = "./modules/cicd-pipeline"
  
  cluster_name     = module.eks.cluster_name
  github_repository = var.github_repository
  branch_name      = var.branch_name
  build_compute_type = var.build_compute_type
  enable_cost_optimization = var.enable_cost_optimization
  
  tags = merge(
    local.common_tags,
    {
      Name        = "${var.cluster_name}-pipeline"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  )
  
  depends_on = [module.eks]
}

# Outputs for the CI/CD pipeline
output "pipeline_name" {
  description = "The name of the CodePipeline"
  value       = module.cicd_pipeline.pipeline_name
}

output "pipeline_url" {
  description = "The URL to access the CodePipeline in the AWS Console"
  value       = "https://${var.aws_region}.console.aws.amazon.com/codesuite/codepipeline/pipelines/${module.cicd_pipeline.pipeline_name}/view?region=${var.aws_region}"
}

output "codebuild_project_name" {
  description = "The name of the CodeBuild project"
  value       = module.cicd_pipeline.codebuild_project_name
}

output "github_connection_status" {
  description = "The current status of the GitHub connection. You'll need to update the connection in the AWS Console to complete the setup."
  value       = "Pending - Requires manual update in AWS Console"
}
