resource "proxmox_virtual_environment_vm" "k3s_vm" {
  name      = var.vm_name
  node_name = var.target_node
  vm_id     = var.vm_id

  clone {
    vm_id         = var.template_vm_id
    full          = true
    datastore_id  = var.storage_name
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = var.storage_name
    interface    = "virtio0"
    size         = 30
    iothread     = true
    discard      = "on"
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    datastore_id = var.storage_name

    ip_config {
      ipv4 {
        address = "dhcp"
        # gateway = "192.168.1.1"  # se estático
      }
    }

    user_account {
      username = "ubuntu"
      keys     = [trimspace(var.ssh_public_key)]
    }

  }

  on_boot = true
  started = true
}

output "vm_ipv4_address" {
  value = proxmox_virtual_environment_vm.k3s_vm.ipv4_addresses[1][0]
}
