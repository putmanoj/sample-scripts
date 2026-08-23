# vmware-vcsim

VMWare VC simulator


## Configuring vSphere provider env vars

```bash
export VSPHERE_USER="administrator@vsphere.local"
export VSPHERE_PASSWORD="SecurePassword"
export VSPHERE_SERVER="localhost:4443"
export VSPHERE_ALLOW_UNVERIFIED_SSL="true"
```

## Using the Go vSphere CLI companion tool: govc

```bash

export GOVC_URL=https://user:pass@127.0.0.1:4443/sdk
export GOVC_INSECURE=true

# Find all simulated VMs
govc find / -type m
```