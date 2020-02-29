variable "cores" {
  type = number
  default = 1
}

variable "memory" {
  type = number
  default = 1024
}

variable "disk_size" {
  type = string
  default = "100G"
}

variable "hostname" {
  type = string
}

variable "ip" {
  type = string
}

resource "random_id" "random_mac" {
  byte_length = 5
}

locals {
  mac = format("66:%s", join(":", regex("(.{2})(.{2})(.{2})(.{2})(.{2})", random_id.random_mac.hex)))
}

resource "proxmox_vm_qemu" "vm" {
  name = var.hostname
  desc = "tf description"
  target_node = "fujari"

  clone = "buster-base-template"
  full_clone = false
  os_type = "cloud-init"
  ci_wait = 15

  agent = 1
  cores = var.cores
  sockets = 1
  memory = var.memory
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  ciuser = "jihartik"
  ipconfig0 = "ip=${var.ip}/24,gw=10.90.70.1"

  disk {
    id = 0
    type = "scsi"
    size = var.disk_size
    cache = "writeback"
    storage = "local-zfs"
    storage_type = "zfspool"
  }

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
    macaddr = local.mac
  }
}

module "dns-name" {
  source = "../chacal.fi-name"
  hostname = var.hostname
  ip = var.ip
}
