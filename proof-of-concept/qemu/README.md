# QEMU Emulation Environment

This directory contains the scripts for setting up a QEMU emulation environment for OpenWRT and BATMAN. The setup is based on the [OpenWRT QEMU Emulation Environment](https://www.open-mesh.org/doc/devtools/Emulation_Environment.html). 

## Setup

To setup the QEMU emulation environment, run the following command:

```bash
$ ./virtual-network.sh
```

This script will create a virtual network, as a bridge `br-qemu`, with 4 tap devices, that can communicate with each other.

## Running the instances

To run the VM instances, first copy the `openwrt-x86-64-generic-ext4-combined-efi.img` image to this directory. You may need to first extract the image from the `openwrt-x86-64-generic-ext4-combined-efi.img.gz` file.

Then, in separate terminals, run the following commands for each instance:

```bash
$ screen
$ ./run.sh <instance_number>
```

The instance number should be between 1 and 4. The script will create, for each instance, a (copy on write) snapshot of the base image. Then, it will start the instance, and connect it to the virtual network, using the tap device corresponding to the instance number. BATMAN is also started on the instance. 