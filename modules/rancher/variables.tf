# AWS General Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string

}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

# Organization and Control Tower Configuration
variable "organization_name" {
  description = "Name of the AWS Organization"
  type        = string

}

variable "organization_email" {
  description = "Email address for the AWS Organizations management account"
  type        = string
}

variable "log_archive_email" {
  description = "Email address for the log archive account"
  type        = string
}

variable "audit_email" {
  description = "Email address for the audit account"
  type        = string
}

variable "enable_guardrails" {
  description = "Enable Control Tower guardrails"
  type        = bool
  default     = true
}

# EKS Configuration
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# Rancher Configuration
variable "rancher_hostname" {
  description = "Hostname for Rancher"
  type        = string
}

variable "rancher_admin_password" {
  description = "Admin password for Rancher"
  type        = string
  sensitive   = true
}

variable "replica_count" {
  description = "Number of Rancher replicas"
  type        = number
  default     = 3
}

# Remove system_node_group if not needed in the Rancher module

# Additional EKS Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.20.0.0/19"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.20.0.0/21", "10.20.8.0/21", "10.20.16.0/21"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.20.24.0/23", "10.20.26.0/23", "10.20.28.0/23"]
}

variable "endpoint_private_access" {
  description = "Enable private API server endpoint access for EKS"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public API server endpoint access for EKS"
  type        = bool
  default     = true
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.32"
}

# Node Group Configuration
variable "general_purpose_node_group" {
  description = "Configuration for the general purpose node group"
  type = object({
    desired_size   = number
    min_size       = number
    max_size       = number
    instance_types = list(string)
    capacity_type  = string
  })
  default = {
    desired_size   = 2
    min_size       = 2
    max_size       = 5
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
  }
}

variable "system_node_group" {
  description = "Configuration for the system node group"
  type = object({
    desired_size = number,
    min_size     = number
  })
}
