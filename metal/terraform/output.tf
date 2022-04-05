
output "Master-IPS" {
  value = values(local.servers.metal.children.masters.hosts)
}

output "example" {
  value = "ip=${local.masters[0].ansible_host}/${var.networkrange},gw=${var.gateway}"
}

output "worker-IPS" {
  value = values(local.servers.metal.children.workers.hosts)
}
