# Applications Pipeline

This pipeline deploys sample applications to the EKS cluster. This is a template pipeline that can be customized for your specific applications.

## Components Deployed

- **Sample Application**: A simple nginx-based application for testing
- **Kubernetes Namespace**: Isolated namespace for the application
- **Service**: ClusterIP service to expose the application internally
- **Ingress**: Optional ingress for external access

## Prerequisites

- Infrastructure pipeline must be deployed
- EKS pipeline must be deployed and cluster accessible
- kubectl configured to access the EKS cluster
- Terraform >= 1.0

## Deployment

1. **Ensure EKS cluster is accessible**:
   ```bash
   kubectl get nodes
   ```

2. **Configure variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Customization

This is a sample application pipeline. To deploy your own applications:

1. Replace the sample application resources with your application manifests
2. Update variables to match your application requirements
3. Modify the Terraform configuration as needed

## Dependencies

- **Infrastructure Pipeline**: Must be deployed first
- **EKS Pipeline**: Must be deployed second and cluster must be accessible

## Notes

- This pipeline uses the local kubeconfig file to connect to the cluster
- The sample application is nginx-based and serves as a template
- Replace this with your actual application deployments as needed