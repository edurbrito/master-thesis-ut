#! /bin/sh

set -e

## Simple batman-adv setup

rmmod batman-adv || true
modprobe batman-adv
batctl routing_algo BATMAN_IV
batctl if add eth0
batctl it 5000
ip link set up dev eth0
ip link set up dev bat0
batctl bl 1

batctl meshif bat0 hop_penalty 255
