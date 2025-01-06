terraform {
  required_version = ">= 1.10.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.1"
    }
  }
}

provider "libvirt" {
  # Configuration options
  uri = var.libvirt_uri
}