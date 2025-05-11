#!/bin/bash

set -e
set -o pipefail

echo
echo "###################"
echo "## OpenTofu demo ##"
echo "###################"
echo

cd opentofu/

echo
echo "##"
echo "# tofu init"
echo "##"
echo

tofu init -var-file=./configurations/demo.tfvars

echo
echo "##"
echo "# tofu plan"
echo "##"
echo

tofu plan -var-file=./configurations/demo.tfvars

read -rs

echo
echo "##"
echo "# tofu apply"
echo "##"
echo

tofu apply -var-file=./configurations/demo.tfvars -auto-approve

read -rs

echo
echo "##"
echo "# State is encrypted!"
echo "##"
echo

cat tfstates/opentofu.tfstate

read -rs

echo
echo "##"
echo "# Values are readable with show and state commands"
echo "##"
echo

tofu show -show-sensitive -var-file=./configurations/demo.tfvars

read -rs

echo
echo "⚠️ Press enter to delete the resources ⚠️"
echo

read -rs

tofu destroy -var-file=./configurations/demo.tfvars -auto-approve

exit 0
