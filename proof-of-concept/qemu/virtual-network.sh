#! /bin/sh

USER="$(whoami)"
BRIDGE=br-qemu
NUM_SESSIONS=4

sudo ip link add "${BRIDGE}" type bridge
for i in $(seq 1 "${NUM_SESSIONS}"); do
        sudo ip tuntap add dev tap$i mode tap user "$USER"
        sudo ip link set tap$i up
        sudo ip link set tap$i master "${BRIDGE}"
done

sudo ip link set "${BRIDGE}" up
sudo ip addr replace 192.168.251.1/24 dev "${BRIDGE}"

# VDESWITCH=vde_switch

# killall -q wirefilter
# killall -q vde_switch

# for i in $(seq 1 "${NUM_SESSIONS}"); do
#     ${VDESWITCH} -d --hub --sock num${i}.ctl
# done

# wirefilter --daemon -v num1.ctl:num2.ctl
# wirefilter --daemon -v num2.ctl:num3.ctl
# wirefilter --daemon -v num3.ctl:num1.ctl
