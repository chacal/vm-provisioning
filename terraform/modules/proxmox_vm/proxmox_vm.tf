resource "random_id" "random_mac" {
  byte_length = 5
}

locals {
  mac = format("66:%s", join(":", regex("(.{2})(.{2})(.{2})(.{2})(.{2})", random_id.random_mac.hex)))
}

resource "null_resource" "user_data_file" {
  connection {
    type = "ssh"
    host = "${var.pm_node}.chacal.fi"
    user = var.pm_user
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    destination = "/var/lib/vz/snippets/user_data-${local.mac}.yml"
    content = templatefile("${path.module}/user_data.tmpl",
    {
      hostname = var.hostname
      fqdn = "${var.hostname}.${var.domain}"
    })
  }
}


resource "proxmox_vm_qemu" "vm" {
  depends_on = [
    null_resource.user_data_file
  ]

  name = var.hostname
  desc = "tf description"
  target_node = var.pm_node

  clone = var.template
  full_clone = length(regexall("^local-zfs$", var.storage)) > 0 ? false : true
  os_type = "cloud-init"
  ci_wait = 15

  agent = 1
  cores = var.cores
  sockets = 1
  memory = var.memory
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  ipconfig0 = "ip=${var.ip}/24,gw=${var.gateway}"
  nameserver = var.nameserver
  searchdomain = var.searchdomain
  cicustom = "user=local:snippets/user_data-${local.mac}.yml"

  disk {
    id = 0
    type = "scsi"
    size = var.disk_size
    cache = "writeback"
    storage = var.storage
    storage_type = "zfspool"
  }

  network {
    id = 0
    model = "virtio"
    bridge = var.bridge
    macaddr = local.mac
    tag = var.vlan
  }

  dynamic "network" {
    for_each = var.extra_network != null ? [1] : []
    content {
      id = 1
      model = "virtio"
      bridge = var.extra_network.bridge
      macaddr = var.extra_network.mac
      tag = var.extra_network.tag
    }
  }
}

module "dns-name" {
  source = "../chacal.fi-name"
  hostname = var.hostname
  ip = var.ip
}
