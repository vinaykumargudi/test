#!/bin/bash

# Exit immediately if a command fails
set -e

# Update package list and install Docker CLI
echo "Updating package list and installing Docker CLI..."

sudo apt remove -y containerd.io  --allow-change-held-packages
apt update && sudo apt install -y docker.io

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
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack

helm install my-release oci://registry-1.docker.io/bitnamicharts/kafka -f https://raw.githubusercontent.com/vinaykumargudi/test/refs/heads/main/values.yaml

echo "Kafka installation completed successfully!"
echo "prometheus  installation started!"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus


kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext


helm repo add grafana https://grafana.github.io/helm-charts 
helm repo update

helm install grafana grafana/grafana

kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext


#kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }


curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
	| sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
	&& echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
	| sudo tee /etc/apt/sources.list.d/ngrok.list \
	&& sudo apt update \
	&& sudo apt install ngrok


 ngrok config add-authtoken 2sfshrEkS9MtvHbAWkFLhmv6MzQ_6RrdL9q6xNbvmffPNsLS3


kubectl port-forward svc/grafana 3000:80 &

ngrok http http://localhost:3000 





