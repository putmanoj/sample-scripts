###############################################################
# This sample to configured to make it run with vmware/vcsim
###############################################################

# ==============================================================================
# 1. PROVIDER & VERSIONS ARCHITECTURE
# ==============================================================================
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.4"
    }
  }
}

provider "vsphere" {
  # Run 'source ../vsphere-env.sh', to configure the vSphere Provider
  allow_unverified_ssl = true
}

# ==============================================================================
# 2. Define inputs
# ==============================================================================

# i. Define your inputs
variable "vm_specs" {
  type = object({
    name     = string
    num_cpus = number
    memory   = number
  })
  default = {
    name     = "app-server-prod-1"
    num_cpus = 4
    memory   = 8192
  }
}

# ii. Create a reactive trigger wrapper
resource "terraform_data" "vm_spec_trigger" {
  input = {
    name     = var.vm_specs.name
    cpus     = var.vm_specs.num_cpus
    mem      = var.vm_specs.memory
  }
}

# ==============================================================================
# 3. VSPHERE DATA DISCOVERY
# ==============================================================================
data "vsphere_datacenter" "dc" {
  name = "DC0" 
}

data "vsphere_datastore" "datastore" {
  name          = "LocalDS_0" 
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "DC0_C0/Resources" 
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "DC0_H0_VM0"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# ==============================================================================
# 3. VIRTUAL MACHINE CLONE RESOURCE DEFINITION
# ==============================================================================
resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_specs.name
  num_cpus         = var.vm_specs.num_cpus
  memory           = var.vm_specs.memory

  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  
  # FIXED: Matches the underlying template string expected by the clone validation rule
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  # Network Interface settings
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  # Storage Layout parameters
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }

  # Instructs Terraform to consider the VM successfully built once the cloning 
  # step finishes, instead of waiting for a mock guest OS network handshake.
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  # OS Cloning Execution
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    
    # The `customize` block has been completely removed. 
    # vcsim does not run guest tools or simulate guest OS engine subsystems, 
    # meaning IP/Hostname injection parameters cannot be emulated here.
  }

  lifecycle {
    # Forces a full destroy/recreate if name, num_cpus, or memory changes
    replace_triggered_by = [
      terraform_data.vm_spec_trigger
    ]
    
    # Optional: Prevents naming conflicts during recreation if naming isn't dynamic
    create_before_destroy = false 
  }
}
