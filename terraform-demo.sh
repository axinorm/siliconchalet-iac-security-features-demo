#!/bin/bash

set -e
set -o pipefail

echo
echo "####################"
echo "## Terraform demo ##"
echo "####################"
echo

cd terraform/

echo
echo "##"
echo "# Create kind cluster"
echo "##"
echo

kind create cluster --name k8s-demo --kubeconfig ./k8s-demo-config 

echo
echo "##"
echo "# terraform init"
echo "##"
echo

terraform init

echo
echo "##"
echo "# terraform plan"
echo "##"
echo

terraform plan -var-file=./configurations/demo.tfvars

read -rs

echo
echo "##"
echo "# terraform apply"
echo "##"
echo

terraform apply -var-file=./configurations/demo.tfvars -auto-approve

read -rs

echo
echo "##"
echo "# tls_private_key is not store in the state file!"
echo "# Some attributes with _wo suffix are not readable!"
echo "##"
echo

terraform show

read -rs

echo
echo "##"
echo "# The Kubernetes Secret contains the public key!"
echo "##"
echo

export KUBECONFIG=./k8s-demo-config
kubectl -n demo get secret my-public-key -o yaml

read -rs

echo
echo "⚠️ Press enter to delete the resources and cluster ⚠️"
echo

read -rs

terraform destroy -var-file=./configurations/demo.tfvars -auto-approve
kind delete cluster --name k8s-demo --kubeconfig ./k8s-demo-config

exit 0
