terraform {
  required_version = ">= 1.0.0"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

provider "vsphere" {
  # Run 'source ../vsphere-env.sh', to configure the vSphere Provider
}

variable "dc_name" {
  type = string
  default = "My-Datacenter-1"
}

resource "vsphere_datacenter" "dc" {
  name = var.dc_name
}
