output "dev_environment_id" {
  description = "The ID of the CodeCatalyst dev environment"
  value       = aws_codecatalyst_dev_environment.main.id
}

output "codecatalyst_space_name" {
  description = "The CodeCatalyst space name"
  value       = var.codecatalyst_space_name
}

output "codecatalyst_project_name" {
  description = "The CodeCatalyst project name"
  value       = var.codecatalyst_project_name
}

output "codebuild_project_name" {
  description = "The name of the CodeBuild project"
  value       = aws_codebuild_project.build.name
}

output "artifacts_bucket_name" {
  description = "The name of the S3 bucket used for artifacts"
  value       = aws_s3_bucket.artifacts.id
}
