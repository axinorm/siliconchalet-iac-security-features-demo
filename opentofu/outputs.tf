output "compute_instance_public_ip" {
  value = exoscale_compute_instance.this.public_ip_address 
}
