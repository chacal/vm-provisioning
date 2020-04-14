locals {
  ip = {
    elastic = "10.50.100.2"
    lxc-builder = "10.50.100.3"
    sensor-backend = "10.50.100.4"
    sensor-backend2 = "10.50.100.5"
    monitor = "10.50.101.2"
    edge-dmz = "10.50.102.2"
    tuuleeko-dmz = "10.50.102.3"
    sensors-dmz = "10.50.102.4"
    signalk-stash-dmz = "10.50.102.5"
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
  hostname = "elastic"
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
  hostname = "lxc-builder"
  cores = 4
  memory = 2048
  storage = "local-zfs-nonbackupped"
}

module "sensor-backend" {
  source = "./modules/proxmox_vm"
  pm_node = "wario"
  providers = {
    proxmox = proxmox.wario
  }
  template = "buster-base-template-2020-03-30"
  ip = local.ip.sensor-backend
  vlan = 100
  hostname = "sensor-backend"
  cores = 8
  memory = 4096
  storage = "local-zfs"
}

module "sensor-backend2" {
  source = "./modules/proxmox_vm"
  template = "buster-base-template-2020-04-04"
  ip = local.ip.sensor-backend2
  vlan = 100
  hostname = "sensor-backend2"
  cores = 8
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
  hostname = "monitor"
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
  hostname = "edge.dmz"
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
  hostname = "tuuleeko.dmz"
  gateway = local.gateway.DMZ
  nameserver = local.gateway.DMZ
  cores = 2
  memory = 1024
  storage = "local-zfs-nonbackupped"
}

module "sensors-dmz" {
  source = "./modules/proxmox_vm"
  pm_node = "wario"
  providers = {
    proxmox = proxmox.wario
  }
  template = "buster-base-template-2020-04-04"
  ip = local.ip.sensors-dmz
  vlan = 102
  hostname = "sensors.dmz"
  gateway = local.gateway.DMZ
  nameserver = local.gateway.DMZ
  cores = 2
  memory = 1024
  storage = "local-zfs-nonbackupped"
}

module "signalk-stash-dmz" {
  source = "./modules/proxmox_vm"
  pm_node = "wario"
  providers = {
    proxmox = proxmox.wario
  }
  template = "buster-base-template-2020-04-04"
  ip = local.ip.signalk-stash-dmz
  vlan = 102
  hostname = "signalk-stash.dmz"
  gateway = local.gateway.DMZ
  nameserver = local.gateway.DMZ
  extra_network = {
    bridge = "wanbr0"
    mac = "00:50:56:00:90:30"
    tag = -1
  }
  cores = 4
  memory = 4096
  storage = "local-zfs"
}
