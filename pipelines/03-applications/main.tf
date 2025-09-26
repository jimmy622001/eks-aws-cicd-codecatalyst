terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

# Kubernetes provider configuration
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Sample Application Namespace
resource "kubernetes_namespace" "sample_app" {
  metadata {
    name = var.namespace
    labels = {
      app         = "sample-application"
      environment = var.environment
    }
  }
}

# Sample Application Deployment
resource "kubernetes_deployment" "sample_app" {
  metadata {
    name      = "sample-app"
    namespace = kubernetes_namespace.sample_app.metadata[0].name
    labels = {
      app = "sample-app"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "sample-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "sample-app"
        }
      }

      spec {
        container {
          image = var.image
          name  = "sample-app"

          port {
            container_port = var.container_port
          }

          resources {
            limits = {
              cpu    = var.resources.limits.cpu
              memory = var.resources.limits.memory
            }
            requests = {
              cpu    = var.resources.requests.cpu
              memory = var.resources.requests.memory
            }
          }

          env {
            name  = "ENVIRONMENT"
            value = var.environment
          }
        }
      }
    }
  }
}

# Sample Application Service
resource "kubernetes_service" "sample_app" {
  metadata {
    name      = "sample-app-service"
    namespace = kubernetes_namespace.sample_app.metadata[0].name
  }

  spec {
    selector = {
      app = "sample-app"
    }

    port {
      port        = var.service_port
      target_port = var.container_port
    }

    type = var.service_type
  }
}

# Sample Application Ingress (optional)
resource "kubernetes_ingress_v1" "sample_app" {
  count = var.enable_ingress ? 1 : 0

  metadata {
    name      = "sample-app-ingress"
    namespace = kubernetes_namespace.sample_app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = var.ingress_host
      http {
        path {
          backend {
            service {
              name = kubernetes_service.sample_app.metadata[0].name
              port {
                number = var.service_port
              }
            }
          }
          path = "/"
        }
      }
    }
  }
}