output "namespace" {
  description = "Application namespace"
  value       = kubernetes_namespace.sample_app.metadata[0].name
}

output "service_name" {
  description = "Application service name"
  value       = kubernetes_service.sample_app.metadata[0].name
}

output "deployment_name" {
  description = "Application deployment name"
  value       = kubernetes_deployment.sample_app.metadata[0].name
}