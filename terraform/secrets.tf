resource "kubernetes_secret_v1" "this" {
  metadata {
    name      = "my-public-key"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }

  type      = "Opaque"
  immutable = true

  data_wo = {
    "publicKey" = ephemeral.tls_private_key.this.public_key_openssh
  }
  data_wo_revision = 1
}
