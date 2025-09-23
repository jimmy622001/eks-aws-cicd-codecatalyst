variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository in format 'owner/repo'"
  type        = string
}

variable "branch_name" {
  description = "Branch to trigger the pipeline"
  type        = string
  default     = "main"
}

variable "build_compute_type" {
  description = "Compute type for CodeBuild"
  type        = string
  default     = "BUILD_GENERAL1_MEDIUM"
}

variable "enable_cost_optimization" {
  description = "Enable cost optimization features like auto-shutdown"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
