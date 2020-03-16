resource "random_id" "random_mac" {
  byte_length = 5
}

locals {
  mac = format("66:%s", join(":", regex("(.{2})(.{2})(.{2})(.{2})(.{2})", random_id.random_mac.hex)))
}

resource "null_resource" "user_data_file" {
  connection {
    type = "ssh"
    host = var.pm_host
    user = var.pm_user
    password = var.pm_password
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
  target_node = "fujari"

  clone = var.template
  full_clone = false
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
}

module "dns-name" {
  source = "../chacal.fi-name"
  hostname = var.hostname
  ip = var.ip
}
