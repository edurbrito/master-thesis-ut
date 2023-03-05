# OpenWRT Builder Docker Image

This directory contains the Dockerfile and supporting files for building the OpenWRT Builder Docker image. The image is based on the official Ubuntu image and contains all the necessary steps and tools to build OpenWRT.

## Building the Image

To build the image, run the following command:

```bash
$ docker build \
    --build-arg OPENWRT_TARGET=x86-64.Linux-x86_64 \
    --build-arg OPENWRT_TARGET_URL=https://downloads.openwrt.org/snapshots/targets/x86/64/openwrt-imagebuilder-x86-64.Linux-x86_64.tar.xz \
    --build-arg CACHEBUST=$(date +%s) \
    --build-arg OPENWRT_PROFILE=generic \
    --build-arg ADDITIONAL_FILES=files \
    -t openwrt-builder .
```

The `OPENWRT_TARGET` and `OPENWRT_TARGET_URL` arguments are used to specify the target and URL for the OpenWRT image builder. The `CACHEBUST` argument is used to bust the Docker cache when the image builder is updated. The `OPENWRT_PROFILE` argument is used to specify the OpenWRT profile to build. The `ADDITIONAL_FILES` argument is used to specify the directory containing additional [`files`](./files/) to copy into the image. The `--build-arg`  arguments are mandatory.

### OpenWRT Targets

The following table lists the available OpenWRT targets and their URLs:

| Target | URL | Profile | Comment |
|--------|-----|---------|---------|
| `x86-64.Linux-x86_64` | https://downloads.openwrt.org/snapshots/targets/x86/64/openwrt-imagebuilder-x86-64.Linux-x86_64.tar.xz | `generic` | |
| `bcm27xx-bcm2708.Linux-x86_64` | https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2708/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64.tar.xz | `rpi` | Ideal for Raspberry Pi Zero |
| `bcm27xx-bcm2709.Linux-x86_64` | https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2709/openwrt-imagebuilder-bcm27xx-bcm2709.Linux-x86_64.tar.xz | `rpi-2` | Ideal for Raspberry Pi 2/3/4 |

## Running the Image

To run the image, run the following command:

```bash
$ docker run --rm -v ./output:/tmp/output openwrt-builder
```

The `-v ./output:/tmp/output` argument is used to mount the [`output`](./output/) directory in the host to the `/tmp/output` directory in the container.

The container will copy the newly built OpenWRT image to the [`output`](./output/) directory.