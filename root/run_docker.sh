#!/bin/bash

# Enable debug mode
set -x

# Update the system
sudo yum update -y

# Install jq
sudo yum install -y jq

# Switch to ec2-user for the following commands
sudo -u ec2-user -i <<'EOF'
# Set variables
SECRET_NAME="mydatabase/credentials"
REGION="ap-southeast-2"
REPOSITORY_NAME="petclinic-dev"
IMAGE_TAG="latest"

# Retrieve AWS Account ID
echo "Retrieving AWS Account ID..."
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Log in to Amazon ECR
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Retrieve secrets from AWS Secrets Manager
echo "Retrieving secrets from AWS Secrets Manager..."
SECRET_STRING=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME --region $REGION --query 'SecretString' --output text)

# Extract variables from the secret
MYSQL_USERNAME=$(echo $SECRET_STRING | jq -r .username)
MYSQL_PASSWORD=$(echo $SECRET_STRING | jq -r .password)
MYSQL_URL=$(echo $SECRET_STRING | jq -r .MYSQL_URL)

# Define other environment variables
MYSQL_DATABASE="petclinic"
DOCKER_IMAGE="$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_TAG"

# Pull the Docker image from ECR
echo "Pulling Docker image from ECR..."
docker pull $DOCKER_IMAGE

# Run the Docker container with the retrieved environment variables
echo "Running Docker container..."
docker run -e MYSQL_URL=$MYSQL_URL -e MYSQL_USER=$MYSQL_USERNAME -e MYSQL_PASSWORD=$MYSQL_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -dp 80:8080 $DOCKER_IMAGE
echo "Docker container started."
EOF
