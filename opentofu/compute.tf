data "exoscale_template" "this" {
  name = "Linux Ubuntu 24.04 LTS 64-bit"

  zone = var.zone
}

resource "exoscale_compute_instance" "this" {
  name = "ci-demo-${var.zone}"

  zone = var.zone

  template_id = data.exoscale_template.this.id

  ssh_keys = [exoscale_ssh_key.this.id]

  type        = "standard.medium"
  disk_size   = 10
}
