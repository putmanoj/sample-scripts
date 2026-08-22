#!/bin/bash

# Configure the vSphere Provider by running 'source env.sh', before running terraform commands

export VSPHERE_USER="administrator@vsphere.local"
export VSPHERE_PASSWORD="SecurePassword"
export VSPHERE_SERVER="${VSPHERE_SERVER:-localhost}"
export VSPHERE_ALLOW_UNVERIFIED_SSL="true"
