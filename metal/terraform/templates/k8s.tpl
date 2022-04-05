metal:
  children:
    masters:
      hosts:
        ${k3s_master_ip}
    workers:
      hosts:
        ${k3s_node_ip}