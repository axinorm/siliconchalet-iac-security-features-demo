##
# Global
##
variable "zone" {
  type        = string
  description = "Zone to deploy the instance"
}

##
# Encryption
##
variable "encryption_passphrase" {
  type        = string
  description = "Passphrase to encrypt the tfstate and tfplan"
}

##
# Backend
##
variable "backend_local_path" {
  type = string
  description = "Path to store the tfstates"
}
