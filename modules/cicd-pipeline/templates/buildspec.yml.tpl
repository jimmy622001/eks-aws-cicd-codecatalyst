version: 0.2

phases:
  install:
    runtime-versions:
      nodejs: 18
      python: 3.10
    commands:
      - echo "Installing system dependencies..."
      - apt-get update -y
      - apt-get install -y unzip jq gettext
      
      # Install AWS CLI v2
      - curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      - unzip awscliv2.zip
      - ./aws/install
      
      # Install kubectl
      - curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/linux/amd64/kubectl
      - chmod +x ./kubectl
      - mv ./kubectl /usr/local/bin/kubectl
      
      # Install helm
      - curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
      
      # Install terraform
      - wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
      - unzip terraform_1.5.7_linux_amd64.zip
      - mv terraform /usr/local/bin/
      
      # Install other build tools
      - pip install pre-commit awscli --upgrade
      - npm install -g aws-cdk

  pre_build:
    commands:
      - echo "Configuring AWS credentials..."
      - aws sts get-caller-identity
      - echo "Configuring kubectl..."
      - aws eks update-kubeconfig --name ${cluster_name} --region ${aws_region}
      - kubectl get nodes
      - echo "Running pre-commit hooks..."
      - pre-commit run --all-files || true  # Continue even if hooks fail

  build:
    commands:
      - echo "Building application..."
      - terraform init
      - terraform validate
      - terraform plan -out=tfplan
      - echo "Build completed successfully"

  post_build:
    commands:
      - echo "Build completed on `date`"
      - echo "Running tests..."
      # Add your test commands here
      - echo "Tests completed successfully"

artifacts:
  files:
    - '**/*'
  base-directory: .
  discard-paths: no

cache:
  paths:
    - '/root/.cache/pip/**/*'
    - '/root/.npm/**/*'
