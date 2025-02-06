#!/bin/bash

# Exit immediately if a command fails
set -e

# Update package list and install Docker CLI
echo "Updating package list and installing Docker CLI..."
apt update && apt install -y docker.io

# Log in to Docker Hub
echo "Logging into Docker Hub..."
docker login -u sentdexcloud9 -p 'Bmwi8@new**'

# Install Helm if not installed
if ! command -v helm &> /dev/null; then
    echo "Helm not found. Installing Helm..."
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Install Kafka using Helm
echo "Installing Kafka using Helm..."
helm install my-release oci://registry-1.docker.io/bitnamicharts/kafka -f https://raw.githubusercontent.com/vinaykumargudi/test/refs/heads/main/values.yaml

echo "Kafka installation completed successfully!"
