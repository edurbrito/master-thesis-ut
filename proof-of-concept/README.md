# Towards Decentralized Proof-of-Location

This repository contains the source code of the proof-of-concept implementation of a decentralized proof-of-location protocol described in the Master's thesis "Towards Decentralized Proof-of-Location", authored by [Eduardo Brito](mailto:eduardo.ribas.brito@ut.ee) and supervised by [Ulrich Norbisrath](mailto:ulrich.norbisrath@ut.ee). 

## Structure

The repository is structured as follows:

- `openwrt-builder/`: contains the Dockerfile and supporting files for building the `openwrt-builder` Docker image, to generate the OpenWrt images used in the proof-of-concept.
- `src/`: contains the source files for the utility programs used in the proof-of-concept.
- `qemu/`: contains the scripts for setting up a QEMU emulation environment for OpenWrt and BATMAN.