variable "pm_user" {
  description = "The username for the proxmox user"
  type        = string
  sensitive   = false
  default     = "root@pam"

}
variable "pm_password" {
  description = "The password for the proxmox user"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Set to true to ignore certificate errors"
  type        = bool
  default     = false
}

variable "pm_host" {
  description = "The hostname or IP of the proxmox server"
  type        = string
}

variable "pm_node_name" {
  description = "name of the proxmox node to create the VMs on"
  type        = string
  default     = "pve"
}

variable "pvt_key" {}

variable "num_k3s_masters_mem" {
  default = "4096"
}

variable "num_k3s_masters_cpu" {
  type    = number
  default = 4
}

variable "num_k3s_nodes_mem" {
  default = "4096"
}

variable "num_k3s_nodes_cpu" {
  type    = number
  default = 4
}

variable "tamplate_vm_name" {}

variable "networkrange" {
  default = 24
}

variable "gateway" {
  default = "192.168.2.1"
}

variable "inventory_file" {
  type        = string
  default     = "hosts.yml"
  description = "Filename for inventory"
}
