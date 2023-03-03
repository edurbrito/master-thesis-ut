# ubuntu based OpenWrt build environment

# build with:
# sudo docker build --progress=plain --build-arg OPENWRT_TARGET=bcm27xx-bcm2708.Linux-x86_64 --build-arg OPENWRT_TARGET_URL=https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2708/openwrt-imagebuilder-bcm27xx-bcm2708.Linux-x86_64.tar.xz --build-arg CUSTOM_PACKAGE_DIR=hello-world --build-arg CUSTOM_PACKAGE_NAME=hello-world -t openwrt-builder .

# run with:
# sudo docker run -v /home/eduardo/Desktop/UNIVERSITY/proof-of-location/proof-of-concept/openwrt-builder/output:/tmp/output openwrt-builder

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
# define the ARG OPENWRT_TARGET and OPENWRT_TARGET_URL
ARG OPENWRT_TARGET
ARG OPENWRT_TARGET_URL
# download OpenWrt imagebuilder
RUN wget ${OPENWRT_TARGET_URL} -O /tmp/openwrt.tar.xz

# extract OpenWrt imagebuilder
RUN mkdir /tmp/openwrt && tar -J -x -f /tmp/openwrt.tar.xz -C /tmp/openwrt

# uncomment batman-adv lines in .config
RUN sed -i 's/# CONFIG_PACKAGE_kmod-batman-adv is not set/CONFIG_PACKAGE_kmod-batman-adv=y/' /tmp/openwrt/openwrt-imagebuilder-${OPENWRT_TARGET}/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_BATMAN_V is not set/CONFIG_BATMAN_ADV_BATMAN_V=y/' /tmp/openwrt/openwrt-imagebuilder-${OPENWRT_TARGET}/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_BLA is not set/CONFIG_BATMAN_ADV_BLA=y/' /tmp/openwrt/openwrt-imagebuilder-${OPENWRT_TARGET}/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_DAT is not set/CONFIG_BATMAN_ADV_DAT=y/' /tmp/openwrt/openwrt-imagebuilder-${OPENWRT_TARGET}/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_NC is not set/CONFIG_BATMAN_ADV_NC=y/' /tmp/openwrt/openwrt-imagebuilder-${OPENWRT_TARGET}/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_MCAST is not set/CONFIG_BATMAN_ADV_MCAST=y/' /tmp/openwrt/openwrt-imagebuilder-${OPENWRT_TARGET}/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_DEBUG is not set/CONFIG_BATMAN_ADV_DEBUG=y/' /tmp/openwrt/openwrt-imagebuilder-${OPENWRT_TARGET}/.config
RUN sed -i 's/# CONFIG_BATMAN_ADV_TRACING is not set/CONFIG_BATMAN_ADV_TRACING=y/' /tmp/openwrt/openwrt-imagebuilder-${OPENWRT_TARGET}/.config

# define the ARG CUSTOM_PACKAGE_NAME and CUSTOM_PACKAGE_DIR
ARG CUSTOM_PACKAGE_DIR
ARG CUSTOM_PACKAGE_NAME
# copy the custom package to the image
ADD --chown=1000:1000 ${CUSTOM_PACKAGE_DIR} /tmp/openwrt/openwrt-imagebuilder-${OPENWRT_TARGET}/files/opt/${CUSTOM_PACKAGE_NAME}

# build image
RUN cd /tmp/openwrt/openwrt-imagebuilder-${OPENWRT_TARGET} && \
    make info && \
    make image PROFILE="rpi" PACKAGES="kmod-batman-adv" FILES="hello-world" && \ 
    mkdir /tmp/output

# for persistence
ENV OPENWRT_TARGET=${OPENWRT_TARGET}

CMD cp -r /tmp/openwrt/openwrt-imagebuilder-$OPENWRT_TARGET/bin/targets/ /tmp/output/ && chown -R 1000:1000 /tmp/output