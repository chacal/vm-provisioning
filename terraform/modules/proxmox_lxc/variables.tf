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

variable "bridge" {
  type = string
  default = "vmbr0"
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

variable "searchdomain" {
  type = string
  default = "chacal.fi"
}

variable "vlan" {
  type = number
}

variable "rootfs_archive" {
  type = string
  default = "debian-10.0-standard_10.0-1_amd64.tar.gz"
}

variable "storage" {
  type = string
  default = "local-zfs"
}

variable "pm_node" {
  type = string
  default = "fujari"
}
