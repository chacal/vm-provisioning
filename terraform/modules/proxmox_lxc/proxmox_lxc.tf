variable "cores" {
  type = number
  default = 1
}

variable "memory" {
  type = number
  default = 1024
}

variable "disk_size" {
  type = number
  default = 100
}

variable "hostname" {
  type = string
}

variable "ip" {
  type = string
}

variable "rootfs_archive" {
  type = string
  default = "debian-10.0-standard_10.0-1_amd64.tar.gz"
}

resource "random_id" "random_mac" {
  byte_length = 5
}

locals {
  mac = format("66:%s", join(":", regex("(.{2})(.{2})(.{2})(.{2})(.{2})", random_id.random_mac.hex)))
}

resource "proxmox_lxc" "lxc" {
  cores = var.cores
  memory = var.memory
  onboot = "true"
  start = "true"

  hostname = var.hostname
  rootfs = "local-zfs:${var.disk_size}"

  network {
    name = "eth0"
    bridge = "vmbr0"
    ip = "${var.ip}/24"
    ip6 = "auto"
    gw = "10.90.70.1"
    hwaddr = local.mac
    firewall = "true"
    rate = 0
    tag = 0
    type = "veth"
  }
  ostemplate = "local:vztmpl/${var.rootfs_archive}"
  ostype = "debian"
  ssh_public_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEApxT0ZP4MsFQ7PC43ugWcGNbHLfXN3kqx0rMMhfGsKCxvhLTGYwveDFfIrimCWWCWg248oNR0jzoH5mKz/stidF8fsVubBegAJ32N/f2jJ6hHlnmCbRBCNlm1BL5Yz+YkMVWTMXa38ICaJhOncDwtZvzUqicc6b7GQmRZ4X7tQTUD91ln7t+7VSqEYXeCmvAL4fY8i2PMlWZoaN6FHmquJYH09w0Hu20Nz5SyfqjYk1vhKnDk93CouTcCR4zONcZdyip7b5qQAHfkcyCqZLvFgadedqsFwe2lu9WgpWATTrJUWReykDzk/jHMaivboXxLaVxwvAmF1CejmWV74VNUFw== jihartik@localhost"
  storage = "local-zfs"
  target_node = "fujari"
  unprivileged = true

  lifecycle {
    ignore_changes = [
      ssh_public_keys,
      ostemplate,
      rootfs,
      storage,
      start
    ]
  }
}

module "dns-name" {
  source = "../chacal.fi-name"
  hostname = var.hostname
  ip = var.ip
}
