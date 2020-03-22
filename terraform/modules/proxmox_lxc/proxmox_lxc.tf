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
  nameserver = var.nameserver
  searchdomain = var.searchdomain
  rootfs = "${var.storage}:${var.disk_size}"

  network {
    name = "eth0"
    bridge = var.bridge
    ip = "${var.ip}/24"
    ip6 = "auto"
    gw = var.gateway
    hwaddr = local.mac
    firewall = "true"
    rate = 0
    tag = var.vlan
    type = "veth"
  }
  ostemplate = "local:vztmpl/${var.rootfs_archive}"
  ostype = "debian"
  ssh_public_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEApxT0ZP4MsFQ7PC43ugWcGNbHLfXN3kqx0rMMhfGsKCxvhLTGYwveDFfIrimCWWCWg248oNR0jzoH5mKz/stidF8fsVubBegAJ32N/f2jJ6hHlnmCbRBCNlm1BL5Yz+YkMVWTMXa38ICaJhOncDwtZvzUqicc6b7GQmRZ4X7tQTUD91ln7t+7VSqEYXeCmvAL4fY8i2PMlWZoaN6FHmquJYH09w0Hu20Nz5SyfqjYk1vhKnDk93CouTcCR4zONcZdyip7b5qQAHfkcyCqZLvFgadedqsFwe2lu9WgpWATTrJUWReykDzk/jHMaivboXxLaVxwvAmF1CejmWV74VNUFw== jihartik@localhost"
  storage = var.storage
  target_node = var.pm_node
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
