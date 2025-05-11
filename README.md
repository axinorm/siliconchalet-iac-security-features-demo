# IaC Security features - OpenTofu vs Terraform

This repository contains two demos for the Silicon Chalet Meetup IaC Best practices.

* [OpenTofu backend encryption](./opentofu/)
* [Terraform ephemeral resources](./terraform/)

## Prerequisites

To run these demos, you will need the following binaries and versions:

* [tofu](https://github.com/opentofu/opentofu/releases), version >= 1.7.0: Create infrastructure with OpenTofu
* [terraform](https://github.com/hashicorp/terraform/releases), version >= 1.11.0: Create infrastructure with Terraform
* [kind](https://kind.sigs.k8s.io/): Create Kubernetes cluster with a container engine like Docker
* [kubectl](https://kubernetes.io/docs/tasks/tools/): Manage resources inside Kubernetes cluster

## First demo: OpenTofu backend encryption

The virtual machine deployed will be in the Cloud Provider [Exoscale](https://www.exoscale.com/), you can create a trial account and set the following parameters as environment variables:

```bash
export EXOSCALE_API_KEY=""
export EXOSCALE_API_SECRET=""
```

Define an encryption passphrase to encrypt the tfstate and tfplan, you can use an environment variable as follows:

```bash
export TF_VAR_encryption_passphrase="schnapps-trespass-unsightly-dweller-bonsai-manhunt" # Passphrase example
```

Then, go to the ``opentofu`` directory and run the ``init``, ``plan`` and finally ``apply`` command:

```bash
cd opentofu/

tofu init -var-file=./configurations/demo.tfvars
tofu plan -var-file=./configurations/demo.tfvars
tofu apply -var-file=./configurations/demo.tfvars
```

As you can see, the state is completely encrypted:

```bash
cat tfstates/opentofu.tfstate
```

```json
{"serial":1,"lineage":"fb7d17fe-...","meta":{"key_provider.pbkdf2.encryption_key":"eyJzYWx...","encryption_version":"v0"}
```

But, it's possible to look at it with the ``tofu show`` or ``tofu state ... `` commands:

```bash
tofu show -show-sensitive -var-file=./configurations/demo.tfvars # Var file is needed for the local backend path
```

```tfvars
# data.exoscale_template.this:
data "exoscale_template" "this" {
    default_user = "ubuntu"
    id           = "c71eb1d9-e537-4f92-9832-7089e6e45fae"
    name         = "Linux Ubuntu 24.04 LTS 64-bit"
    visibility   = "public"
    zone         = "ch-gva-2"
}

# exoscale_compute_instance.this:
resource "exoscale_compute_instance" "this" {
    created_at          = "2025-05-11 14:52:04 +0000 UTC"
    disk_size           = 10
[...]
```

Final step: don't forget to destroy resources!

```bash
tofu destroy -var-file=./configurations/demo.tfvars
```

## Second demo: Terraform ephemeral resources

Exoscale has not yet implemented write-only attributes for resources, so it's not currently possible to use the [``ephemeral "tls_private_key"`` resource](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/ephemeral-resources/private_key).

To get around of this, you can use the Kubernetes providers to push the public key in a ``Secret`` resource as a demo.

```bash
cd terraform/
kind create cluster --name k8s-demo --kubeconfig ./k8s-demo-config
```

To run the demo, go to the ``terraform`` directory and run the ``init``, ``plan`` and finally ``apply`` command:

```bash
terraform init
terraform plan -var-file=./configurations/demo.tfvars
terraform apply -var-file=./configurations/demo.tfvars
```

You can check the state file as it should be containing only the ``kubernetes_secret_v1`` resource with some *write-only attribute*:

```bash
terraform show
```

```bash
[...]
# kubernetes_secret_v1.this:
resource "kubernetes_secret_v1" "this" {
    binary_data_wo                 = (write-only attribute)
    data_wo                        = (write-only attribute)
    data_wo_revision               = 1
[...]
```

You can check the resource in the Kubernetes cluster:

```bash
export KUBECONFIG=./k8s-demo-config
kubectl -n demo get secret my-public-key -o yaml
```

```yaml
apiVersion: v1
data:
  publicKey: [...]
immutable: true
kind: Secret
metadata:
  creationTimestamp: "2025-05-11T17:23:29Z"
  name: my-public-key
  namespace: demo
[...]
```

Final step: don't forget to destroy resources!

```bash
terraform destroy -var-file=./configurations/demo.tfvars
kind delete cluster --name k8s-demo --kubeconfig ./k8s-demo-config
```
