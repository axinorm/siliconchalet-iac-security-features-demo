resource "tls_private_key" "this" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "exoscale_ssh_key" "this" {
  name       = "ssh-key-demo"

  public_key = tls_private_key.this.public_key_openssh
}
