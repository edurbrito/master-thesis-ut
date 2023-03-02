# ubuntu based OpenWrt build environment

FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    build-essential \
    libncurses5-dev \
    libncursesw5-dev \
    zlib1g-dev \
    gawk \
    git \
    gettext \
    libssl-dev \
    xsltproc \
    rsync \
    wget \
    unzip \
    python3 \
    python3-distutils \
    file

# download OpenWrt imagebuilder
RUN wget https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2708/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64.tar.xz -O /tmp/openwrt.tar.xz

# extract OpenWrt imagebuilder
RUN mkdir /tmp/openwrt && tar -J -x -f /tmp/openwrt.tar.xz -C /tmp/openwrt

# uncomment batman-adv lines in .config
RUN sed -i 's/# CONFIG_PACKAGE_kmod-batman-adv is not set/CONFIG_PACKAGE_kmod-batman-adv=y/' /tmp/openwrt/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_BATMAN_V is not set/CONFIG_BATMAN_ADV_BATMAN_V=y/' /tmp/openwrt/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_BLA is not set/CONFIG_BATMAN_ADV_BLA=y/' /tmp/openwrt/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_DAT is not set/CONFIG_BATMAN_ADV_DAT=y/' /tmp/openwrt/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_NC is not set/CONFIG_BATMAN_ADV_NC=y/' /tmp/openwrt/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_MCAST is not set/CONFIG_BATMAN_ADV_MCAST=y/' /tmp/openwrt/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_DEBUG is not set/CONFIG_BATMAN_ADV_DEBUG=y/' /tmp/openwrt/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_TRACING is not set/CONFIG_BATMAN_ADV_TRACING=y/' /tmp/openwrt/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64/.config

# define the ARG CUSTOM_PACKAGE_NAME and CUSTOM_PACKAGE_DIR
ARG CUSTOM_PACKAGE_DIR
ARG CUSTOM_PACKAGE_NAME
# copy the custom package to the image
ADD --chown=1000:1000 ${CUSTOM_PACKAGE_DIR} /tmp/openwrt/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64/files/opt/${CUSTOM_PACKAGE_NAME}

# build image
RUN cd /tmp/openwrt/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64 && \
    make info && \
    make image PROFILE="rpi" PACKAGES="kmod-batman-adv"

RUN mkdir /tmp/output && cp /tmp/openwrt/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64/bin/targets/bcm27xx/bcm2708/* /tmp/output/

RUN ls -la /tmp/output/