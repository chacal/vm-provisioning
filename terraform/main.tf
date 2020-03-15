variable "pm_password" {
  type = string
}

module "lxc-builder" {
  pm_password = var.pm_password
  source = "./modules/proxmox_vm"
  template = "buster-base-template-2020-03-14"
  ip = "10.90.70.39"
  hostname = "lxc-builder.chacal.fi"
  cores = 4
  memory = 2048
}

module "terraform-lxc" {
  source = "./modules/proxmox_lxc"
  ip = "10.90.70.41"
  hostname = "terraform-lxc.chacal.fi"
  rootfs_archive = "lxc-buster-base-2020-03-01.tar.gz"
}
