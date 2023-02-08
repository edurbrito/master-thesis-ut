# This script builds a docker image and runs a docker container
# to serve as builder for custom OpenWRT images 
# with user specified packages.
# example usage: ./ubuntu-openwrt-builder.sh /home/edurbrito/Projects/UTARTU-5Y2S/proof-of-concept/

# verify arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <path to build directory>"
    exit 1
fi

# read arguments
# $1: path to build directory
BUILD_DIR=$1

# build docker image
sudo docker build \
    -t ubuntu-openwrt-builder:latest \
    -f ./ubuntu-openwrt-builder.Dockerfile .

# run docker container
sudo docker run \
    --name ubuntu-openwrt-builder -d \
    -v "${BUILD_DIR}":/home \
    ubuntu-openwrt-builder:latest

# exec git clone in the host
git clone https://git.openwrt.org/openwrt/openwrt.git "${BUILD_DIR}/openwrt"

# exec update feeds
sudo docker exec \
    ubuntu-openwrt-builder \
    ./openwrt/scripts/feeds update -a

# exec install feeds
sudo docker exec \
    ubuntu-openwrt-builder \
    ./openwrt/scripts/feeds install -a

# # bash into container
# sudo docker exec -it ubuntu-openwrt-builder bash

# # ... Run the following commands in the container
# $ cd openwrt
# # configure
# $ make menuconfig
# # make toolchain
# $ make toolchain/install
# # build the image, -j 4 for 4 threads
# $ make -j 4