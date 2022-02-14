variable "pm_password_fujari" {
  type = string
}

variable "pm_password_wario" {
  type = string
}

terraform {
  backend "s3" {
    bucket = "terraform-state-chacal"
    key    = "home-infra.tfstate"
    region = "eu-north-1"
  }

  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.7.4"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url = "https://fujari.chacal.fi:8006/api2/json"
  pm_user = "root@pam"
  pm_password = var.pm_password_fujari
  pm_parallel = 10
}

provider "proxmox" {
  alias = "wario"
  pm_tls_insecure = true
  pm_api_url = "https://wario.internal.chacal.fi:8006/api2/json"
  pm_user = "root@pam"
  pm_password = var.pm_password_wario
  pm_parallel = 10
}
