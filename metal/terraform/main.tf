data "local_file" "inventory" {
  filename = "${path.module}/${var.inventory_file}"
}

locals {
  servers = yamldecode(data.local_file.inventory.content)
  masters = values(local.servers.metal.children.masters.hosts)
  workers = values(local.servers.metal.children.workers.hosts)
}

resource "proxmox_vm_qemu" "proxmox_vm_master" {
  count       = length(local.masters)
  vmid        = 200 + count.index
  name        = "k3s-master-${count.index}"
  target_node = var.pm_node_name
  clone       = var.tamplate_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_masters_mem * 1024
  cores       = var.num_k3s_masters_cpu
  ipconfig0   = "ip=${local.masters[count.index].ansible_host}/${var.networkrange},gw=${var.gateway}"

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "100G"
    format  = "raw"
    ssd     = 1
    discard = "on"
  }

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      disk,
      network
    ]
  }
}

resource "proxmox_vm_qemu" "proxmox_vm_workers" {
  count       = length(local.workers)
  vmid        = 205 + count.index
  name        = "k3s-worker-${count.index}"
  target_node = var.pm_node_name
  clone       = var.tamplate_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_nodes_mem * 1024
  cores       = var.num_k3s_nodes_cpu
  ipconfig0   = "ip=${local.workers[count.index].ansible_host}/${var.networkrange},gw=${var.gateway}"

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "100G"
    format  = "raw"
    ssd     = 1
    discard = "on"
  }

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      disk,
      network
    ]
  }

}


# // PXE - Could not get it to work
# resource "proxmox_vm_qemu" "proxmox_vm_master" {
#   count       = length(local.masters)
#   name        = "k3s-master-${count.index}"
#   vmid        = 200 + count.index
#   agent       = 0
#   boot        = "order=net0;scsi0"
#   pxe         = true
#   os_type     = "ubuntu"
#   oncreate    = false
#   target_node = var.pm_node_name
#   memory      = var.num_k3s_masters_mem * 1024
#   cores       = var.num_k3s_masters_cpu

#   disk {
#     type    = "scsi"
#     storage = "local-lvm"
#     size    = "100G"
#     ssd     = 1
#     discard = "on"
#   }

#   // ipconfig0 = "ip=${local.masters[count.index].ansible_host}/${var.networkrange},gw=${var.gateway}"

#   network {
#     bridge    = "vmbr0"
#     firewall  = false
#     link_down = false
#     model     = "virtio"
#     macaddr   = local.masters[count.index].mac
#   }

#   lifecycle {
#     ignore_changes = [

#     ]
#   }
# }
# resource "proxmox_vm_qemu" "proxmox_vm_workers" {
#   count       = length(local.workers)
#   name        = "k3s-worker-${count.index}"
#   agent       = 0
#   vmid        = 210 + count.index
#   boot        = "order=net0;scsi0"
#   pxe         = true
#   os_type     = "ubuntu"
#   target_node = var.pm_node_name
#   memory      = var.num_k3s_nodes_mem * 1024
#   cores       = var.num_k3s_nodes_cpu
#   oncreate    = false

#   disk {
#     type    = "scsi"
#     storage = "local-lvm"
#     size    = "100G"
#     ssd     = 1
#     discard = "on"
#   }

#   //ipconfig0 = "ip=${local.masters[count.index].ansible_host}/${var.networkrange},gw=${var.gateway}"

#   network {
#     bridge    = "vmbr0"
#     firewall  = false
#     link_down = false
#     model     = "virtio"
#     macaddr   = local.workers[count.index].mac
#   }

#   lifecycle {
#     ignore_changes = [

#     ]
#   }
# }



# data "template_file" "k8s" {
#   template = file("./templates/k8s.tpl")
#   vars = {
#     k3s_master_ip = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_master : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
#     k3s_node_ip   = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_workers : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
#   }
# }

# resource "local_file" "k8s_file" {
#   content  = data.template_file.k8s.rendered
#   filename = "../inventory/my-cluster/hosts.ini"
# }

# resource "local_file" "var_file" {
#   source   = "../inventory/sample/group_vars/all.yml"
#   filename = "../inventory/my-cluster/group_vars/all.yml"
# }
