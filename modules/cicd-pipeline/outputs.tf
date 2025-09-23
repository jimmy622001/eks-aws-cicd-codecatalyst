output "pipeline_name" {
  description = "The name of the CodePipeline"
  value       = aws_codepipeline.pipeline.name
}

output "pipeline_arn" {
  description = "The ARN of the CodePipeline"
  value       = aws_codepipeline.pipeline.arn
}

output "codebuild_project_name" {
  description = "The name of the CodeBuild project"
  value       = aws_codebuild_project.build.name
}

output "artifacts_bucket_name" {
  description = "The name of the S3 bucket used for pipeline artifacts"
  value       = aws_s3_bucket.artifacts.id
}

output "github_connection_arn" {
  description = "The ARN of the CodeStar connection to GitHub"
  value       = aws_codestarconnections_connection.github.arn
}
