locals {
  ip = {
    elastic = "10.50.100.2"
    lxc-builder = "10.50.100.3"
    monitor = "10.50.101.2"
    edge-dmz = "10.50.102.2"
    tuuleeko-dmz = "10.50.102.3"
  }
  gateway = {
    MONITOR = "10.50.101.1"
    DMZ = "10.50.102.1"
  }
}

module "elastic" {
  source = "./modules/proxmox_vm"
  pm_node = "wario"
  providers = {
    proxmox = proxmox.wario
  }
  template = "buster-base-template-2020-03-21"
  ip = local.ip.elastic
  vlan = 100
  hostname = "elastic.chacal.fi"
  cores = 6
  memory = 8192
}

module "lxc-builder" {
  source = "./modules/proxmox_vm"
  pm_node = "wario"
  providers = {
    proxmox = proxmox.wario
  }
  template = "buster-base-template-2020-03-21"
  ip = local.ip.lxc-builder
  vlan = 100
  hostname = "lxc-builder.chacal.fi"
  cores = 4
  memory = 2048
  storage = "local-zfs-nonbackupped"
}

module "monitor" {
  source = "./modules/proxmox_vm"
  pm_node = "wario"
  providers = {
    proxmox = proxmox.wario
  }
  template = "buster-base-template-2020-03-21"
  ip = local.ip.monitor
  vlan = 101
  hostname = "monitor.chacal.fi"
  gateway = local.gateway.MONITOR
  nameserver = local.gateway.MONITOR
  cores = 2
  memory = 2048
  storage = "local-zfs"
}

module "edge-dmz" {
  source = "./modules/proxmox_vm"
  pm_node = "wario"
  providers = {
    proxmox = proxmox.wario
  }
  template = "buster-base-template-2020-03-30"
  ip = local.ip.edge-dmz
  vlan = 102
  hostname = "edge.dmz.chacal.fi"
  gateway = local.gateway.DMZ
  nameserver = local.gateway.DMZ
  extra_network = {
    bridge = "wanbr0"
    mac = "00:50:56:00:F2:FB"
    tag = -1
  }
  cores = 1
  memory = 512
  storage = "local-zfs-nonbackupped"
}

module "tuuleeko-dmz" {
  source = "./modules/proxmox_vm"
  pm_node = "wario"
  providers = {
    proxmox = proxmox.wario
  }
  template = "buster-base-template-2020-03-30"
  ip = local.ip.tuuleeko-dmz
  vlan = 102
  hostname = "tuuleeko.dmz.chacal.fi"
  gateway = local.gateway.DMZ
  nameserver = local.gateway.DMZ
  cores = 2
  memory = 1024
  storage = "local-zfs-nonbackupped"
}
