# AWS CI/CD Pipeline
module "cicd_pipeline" {
  source = "./modules/cicd-pipeline"

  cluster_name                  = module.eks.cluster_name
  codecatalyst_space_name       = var.codecatalyst_space_name
  codecatalyst_project_name     = var.codecatalyst_project_name
  repository_name               = var.repository_name
  branch_name                   = var.branch_name
  build_compute_type            = var.build_compute_type
  enable_cost_optimization      = var.enable_cost_optimization
  dev_environment_instance_type = var.dev_environment_instance_type
  inactivity_timeout_minutes    = var.inactivity_timeout_minutes
  storage_size                  = var.storage_size

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

# Outputs for the CodeCatalyst pipeline
output "codecatalyst_dev_environment_id" {
  description = "The ID of the CodeCatalyst dev environment"
  value       = module.cicd_pipeline.dev_environment_id
}

output "codecatalyst_space_name" {
  description = "The CodeCatalyst space name"
  value       = module.cicd_pipeline.codecatalyst_space_name
}

output "codecatalyst_project_name" {
  description = "The CodeCatalyst project name"
  value       = module.cicd_pipeline.codecatalyst_project_name
}

output "codebuild_project_name" {
  description = "The name of the CodeBuild project"
  value       = module.cicd_pipeline.codebuild_project_name
}

output "codecatalyst_role_arn" {
  description = "The ARN of the CodeCatalyst IAM role"
  value       = module.cicd_pipeline.codecatalyst_role_arn
}

# Grant CodeCatalyst role access to EKS cluster
resource "aws_eks_access_entry" "codecatalyst" {
  cluster_name  = module.eks.cluster_name
  principal_arn = module.cicd_pipeline.codecatalyst_role_arn
  type          = "STANDARD"

  depends_on = [module.eks, module.cicd_pipeline]
}

resource "aws_eks_access_policy_association" "codecatalyst" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = module.cicd_pipeline.codecatalyst_role_arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.codecatalyst]
}
