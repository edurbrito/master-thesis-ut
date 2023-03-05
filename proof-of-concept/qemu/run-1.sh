#! /bin/bash

BOOTARGS=()

if [ -z "${STY}" ]; then
    echo "must be started inside a screen session" >&2
    exit 1
fi

NUM_SESSION=1

## OpenWrt in QEMU
BASE_IMG=openwrt-x86-64-generic-ext4-combined.img
BOOTARGS+=("-serial" "chardev:charconsole0")


if [ ! -e "/sys/class/net/tap${NUM_SESSION}" ]; then
    echo "hub script must be started first to create tap$NUM_SESSION interface" >&2
    exit 1
fi


normalized_id="$(echo "$NUM_SESSION"|awk '{ printf "%02d\n",$1 }')"
twodigit_id="$(echo $NUM_SESSION|awk '{ printf "%02X", $1 }')"

qemu-img create -b "${BASE_IMG}" -f qcow2 root.cow$NUM_SESSION -F raw
screen qemu-system-x86_64 -enable-kvm -name "instance${NUM_SESSION}" \
    -display none -no-user-config -nodefaults \
    -m 512M,maxmem=2G,slots=2 -device virtio-balloon \
    -cpu host -smp 2 -machine q35,accel=kvm,usb=off,dump-guest-core=off \
    -device virtio-scsi-pci \
    -device scsi-hd,drive=drive0 \
    -drive file=root.cow$NUM_SESSION,if=none,id=drive0,cache=unsafe,discard=unmap \
    -nic tap,ifname=tap$NUM_SESSION,script=no,downscript=no,model=virtio,mac=02:ba:de:af:fe:"${twodigit_id}" \
    -nic user,model=virtio,mac=06:ba:de:af:fe:"${twodigit_id}" \
    -gdb tcp:127.0.0.1:$((23000+$NUM_SESSION)) \
    -device virtio-rng \
    -device virtio-serial,id=virtio-serial \
    -chardev stdio,id=charconsole0,mux=on,signal=off -mon chardev=charconsole0,mode=readline \
    "${BOOTARGS[@]}"
sleep 1

# -nic vde,sock=num$NUM_SESSION.ctl,port=1,model=virtio-net-pci,mac=02:ba:de:af:ff:"${twodigit_id}" \
