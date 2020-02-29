module "terraform-vm" {
  source = "./modules/proxmox_vm"
  ip = "10.90.70.39"
  hostname = "terraform-vm.chacal.fi"
}

module "terraform-lxc" {
  source = "./modules/proxmox_lxc"
  ip = "10.90.70.41"
  hostname = "terraform-lxc.chacal.fi"
}
