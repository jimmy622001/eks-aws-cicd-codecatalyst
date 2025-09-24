# Production Environment Configuration

# AWS Configuration
aws_region     = "eu-west-1"
s3_bucket_name = "ctse-eks-rancher-prod-123456"

# EKS Cluster Configuration
cluster_name       = "ctse-prod-cluster"
kubernetes_version = "1.32"
environment        = "prod"



# Network Configuration
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
private_subnets    = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

# Rancher Configuration
rancher_hostname       = "rancher-prod.ctse.com"
rancher_admin_password = "Pa55Word" # Change this to a secure password

# Kafka Configuration
replica_count         = 3
kafka_replica_count   = 3
kafka_storage_size    = "100Gi"
kafka_storage_class   = "gp3"
kafka_namespace       = "kafka"

# Security Configuration
endpoint_private_access = true
endpoint_public_access  = false

# Organization Settings
organization_name  = "ctse-prod"
organization_email = "jimmy622001@gmail.com"
log_archive_email  = "jimmy622001@gmail.com"
audit_email        = "jimmy622001@gmail.com"



# Monitoring Configuration
grafana_admin_password = "Pa55Word" # Change this to a secure password

# Security Scanning Tokens (set these in your environment or use AWS Secrets Manager)
sonarqube_token = ""
snyk_token = ""
trivy_token = ""

# Notification Settings
slack_webhook_url = ""
notification_email = ""
