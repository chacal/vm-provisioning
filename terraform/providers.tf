terraform {
  backend "s3" {
    bucket = "terraform-state-chacal"
    key    = "home-infra.tfstate"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = "eu-north-1"
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url = "https://fujari.chacal.fi:8006/api2/json"
}
