variable "pve_endpoint" {
  type        = string
  description = "The PVE endpoint to connect to (eg https://192.168.1.1:8006)"
}

variable "pve_user" {
  type        = string
  description = "The PVE user to use against the API"
}

variable "pve_password" {
  type        = string
  description = "The PVE password to use against the API"
}

