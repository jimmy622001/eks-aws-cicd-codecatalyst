variable "namespace" {
  description = "Kubernetes namespace for the sample application"
  type        = string
  default     = "sample-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "replicas" {
  description = "Number of application replicas"
  type        = number
  default     = 2
}

variable "image" {
  description = "Container image for the sample application"
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "service_port" {
  description = "Service port"
  type        = number
  default     = 80
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "ClusterIP"
}

variable "enable_ingress" {
  description = "Enable ingress for the application"
  type        = bool
  default     = false
}

variable "ingress_host" {
  description = "Ingress hostname"
  type        = string
  default     = "sample-app.local"
}

variable "resources" {
  description = "Resource requests and limits"
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
    limits = {
      cpu    = "500m"
      memory = "512Mi"
    }
  }
}