FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    ccache \
    ecj \
    fastjar \
    file \
    g++ \
    gawk \
    gettext \
    git \
    java-propose-classpath \
    libelf-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libssl-dev \
    python2.7-dev \
    python3 \
    unzip \
    wget \
    python3-distutils \
    python3-setuptools \
    rsync \
    subversion \
    swig \
    time \
    xsltproc \
    zlib1g-dev

# Change to /home directory
WORKDIR /home

# Export staging directory to PATH
ENV PATH="/home/openwrt/staging_dir/host/bin:${PATH}"

# Run the container without exiting
ENTRYPOINT ["tail", "-f", "/dev/null"]
