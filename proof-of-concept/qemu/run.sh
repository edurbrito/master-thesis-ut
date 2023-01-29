#! /bin/bash

BOOTARGS=()

if [ -z "${STY}" ]; then
    echo "must be started inside a screen session" >&2
    exit 1
fi

SHARED_PATH="$(pwd)"
NUM_SESSIONS=3

## OpenWrt in QEMU
BASE_IMG=openwrt-x86-generic-generic-ext4-combined.img
BOOTARGS+=("-serial" "chardev:charconsole0")

for i in $(seq 1 "${NUM_SESSIONS}"); do
    if [ ! -e "/sys/class/net/tap${i}" ]; then
        echo "hub script must be started first to create tap$i interface" >&2
        exit 1
    fi
done

for i in $(seq 1 "${NUM_SESSIONS}"); do
    normalized_id="$(echo "$i"|awk '{ printf "%02d\n",$1 }')"
    twodigit_id="$(echo $i|awk '{ printf "%02X", $1 }')"

    qemu-img create -b "${BASE_IMG}" -f qcow2 root.cow$i -F raw
    screen qemu-system-x86_64 -enable-kvm -name "instance${i}" \
        -display none -no-user-config -nodefaults \
        -m 512M,maxmem=2G,slots=2 -device virtio-balloon \
        -cpu host -smp 2 -machine q35,accel=kvm,usb=off,dump-guest-core=off \
        -device virtio-scsi-pci \
        -device scsi-hd,drive=drive0 \
        -drive file=root.cow$i,if=none,id=drive0,cache=unsafe,discard=unmap \
        -nic tap,ifname=tap$i,script=no,downscript=no,model=virtio,mac=02:ba:de:af:fe:"${twodigit_id}" \
        -nic user,model=virtio,mac=06:ba:de:af:fe:"${twodigit_id}" \
        -virtfs local,path="${SHARED_PATH}",security_model=none,mount_tag=host \
        -gdb tcp:127.0.0.1:$((23000+$i)) \
        -device virtio-rng \
        -device virtio-serial,id=virtio-serial \
        -chardev stdio,id=charconsole0,mux=on,signal=off -mon chardev=charconsole0,mode=readline \
        "${BOOTARGS[@]}"
    sleep 1
done
