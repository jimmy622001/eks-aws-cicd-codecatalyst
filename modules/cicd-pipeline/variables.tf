variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "codecatalyst_space_name" {
  description = "CodeCatalyst space name"
  type        = string
}

variable "codecatalyst_project_name" {
  description = "CodeCatalyst project name"
  type        = string
}

variable "repository_name" {
  description = "CodeCatalyst repository name"
  type        = string
}

variable "dev_environment_instance_type" {
  description = "Instance type for CodeCatalyst dev environment"
  type        = string
  default     = "dev.standard1.medium"
}

variable "inactivity_timeout_minutes" {
  description = "Inactivity timeout for dev environment in minutes"
  type        = number
  default     = 15
}

variable "storage_size" {
  description = "Storage size for dev environment in GB"
  type        = number
  default     = 16
}

variable "branch_name" {
  description = "Branch for CodeCatalyst workflows"
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
