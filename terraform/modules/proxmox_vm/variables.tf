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

variable "gateway" {
  type = string
  default = "10.50.100.1"
}

variable "nameserver" {
  type = string
  default = "10.50.100.1"
}

variable "domain" {
  type = string
  default = "chacal.fi"
}

variable "searchdomain" {
  type = string
  default = "chacal.fi"
}

variable "bridge" {
  type = string
  default = "vmbr0"
}

variable "vlan" {
  type = number
}

variable "template" {
  type = string
}

variable "storage" {
  type = string
  default = "local-zfs"
}

variable "pm_node" {
  type = string
  default = "fujari"
}

variable "pm_user" {
  type = string
  default = "root"
}

variable "extra_network" {
  type = object({
    bridge = string
    mac = string
    tag = number
  })
  default = null
}