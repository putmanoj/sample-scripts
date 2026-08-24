# vmware-vcsim
VMWare VC simulator

## Getting started
```bash
## Start in non-detached ( ctrl+c to stop )
% make

## Start in detached mode, run in back-ground
% make start

## Save current vcsim state (saved to ./vcsim-data/saved-state)
% make vcsim-data-save

## Stop vcsim running in back-ground (the current vcsim state will be saved before stop)
% make stop
```

## Using with Terraform vSphere provider

### Configure the Environment
```bash
export VSPHERE_USER="user"
export VSPHERE_PASSWORD="pass"
export VSPHERE_SERVER="localhost:4443"
export VSPHERE_ALLOW_UNVERIFIED_SSL="true"
```

## Using the Go vSphere CLI companion tool: govc

### Configure the Environment
```bash
export GOVC_URL="https://user:pass@127.0.0.1:4443/sdk";
export GOVC_INSECURE=true;
```

### govc examples
```bash
## Find all simulated VMs
govc find / -type m

## Find all simulated DataCenter/s
govc find / -type d

## List just the VM names (clean list)
govc ls /DC0/vm

## Find Resource Pool
govc find / -type ResourcePool
# /DC0/host/DC0_H0/Resources
# /DC0/host/DC0_C0/Resources

## Find the Exact Network Path
govc find / -type Network
# /DC0/network/VM Network
# /DC0/network/DVS0-DVUplinks-8
# /DC0/network/DC0_DVPG0
# /My-Datacenter-1/network/VM Network

## Create VM
export GOVC_DATACENTER="DC0"; \
govc vm.create \
  -pool="/DC0/host/DC0_C0/Resources" \
  -net="/DC0/network/DC0_DVPG0" \
  -m 4096 \
  -c 2 \
  -g ubuntu64Guest \
  -disk "20GB" \
  -net.adapter vmxnet3 \
  -disk.controller pvscsi \
  -on=false \
  my-new-vm

## Fetch Extended VM Details
## govc object.collect /DC0/vm/<VM> name summary.config.guestIdCode summary.runtime.powerState
govc object.collect /DC0/vm/my-new-vm name summary.config.guestIdCode summary.runtime.powerState
# name                        string                          my-new-vm
# summary.runtime.powerState  types.VirtualMachinePowerState  poweredOff

# Power off VM
govc vm.power -off my-new-vm
# Powering off VirtualMachine:vm-87... OK

# Customize VM
govc vm.customize -vm my-new-vm -name fourtythree -ip 10.0.0.43

# Power on VM
govc vm.power -on my-new-vm
# Powering on VirtualMachine:vm-87... OK

govc object.collect -s vm/my-new-vm guest.ipAddress guest.hostName
# 10.0.0.43
# fourtythree

govc vm.ip my-new-vm
# 10.0.0.43

govc object.collect -s vm/my-new-vm overallStatus
# green

govc vm.change -vm vm/my-new-vm -e SET.overallStatus=red

govc object.collect -s vm/my-new-vm overallStatus
# red
```

