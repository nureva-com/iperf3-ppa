#!/bin/bash

## This script is meant to setup ad debian package for iperf3 version 3.2 which at this time does not have it's
## own ppa. 

IPERF3_GIT_VERSION=3.20
IPERF3_SEMANTIC_VERSION=3.2

ARCH=$(uname -m)

# Check that all needed packages are installed
INSTALL_COUNT=$(dpkg-query -l build-essential libtool pkg-config automake autoconf pkg-config libssl-dev | grep "ii" -c)
if  [ $INSTALL_COUNT -ne 6 ]; then
    echo "Please run 'sudo apt install -y build-essential libtool pkg-config automake autoconf pkg-config libssl-dev' to install dependencies"
    exit 1
fi

if [ "$ARCH" == "aarch64" ]; then
    export ARCH_SUFFIX=arm64
elif [ "$ARCH" == "x86_64" ]; then
    export ARCH_SUFFIX=amd64
else 
    echo "Architecture $ARCH not supported here"
    exit 1
fi

echo "Building iperf3"

WRK_DIR=$PWD/.wrk
PACKAGE_DIR=$WRK_DIR/package
mkdir -p $PACKAGE_DIR

# We clone iperf3 repo
if [[ ! -d $WRK_DIR/iperf3 ]]; then
    git clone \
        -b ${IPERF3_GIT_VERSION} \
        --recursive https://github.com/esnet/iperf.git \
        $WRK_DIR/iperf3

    if [ $? -ne 0 ]; then
        echo "failed to clone repo quiting."
        exit 1
    fi
fi

# Build iperf3 
echo "Build iperf3..."
(cd $WRK_DIR/iperf3 && ./bootstrap.sh)
(cd $WRK_DIR/iperf3 && ./configure --enable-static --disable-shared --prefix=/usr/bin)
(cd $WRK_DIR/iperf3 && make)

# Build package directories
mkdir -p $PACKAGE_DIR/DEBIAN
mkdir -p $PACKAGE_DIR/usr/bin

# Add control text to bin package
cat << EOF > $PACKAGE_DIR/DEBIAN/control 
Package: iperf${IPERF3_SEMANTIC_VERSION}
Version: ${IPERF3_SEMANTIC_VERSION}
Section: universe/libs
Priority: optional
Source: iperf${IPERF3_SEMANTIC_VERSION}
Architecture: $ARCH_SUFFIX
Maintainer: Kevin Lutzer <kevinlutzer@nureva.com>
Description: iperf3 ${IPERF3_SEMANTIC_VERSION} for Ubuntu Linux, made for Ubuntu 24.04
Homepage: https://github.com/esnet/iperf
EOF

# Copy all of the files into the package directories
cp -r $WRK_DIR/iperf3/src/iperf3 $PACKAGE_DIR/usr/bin

# Build the packages and put it in the current working directory
dpkg-deb --root-owner-group --build $PACKAGE_DIR iperf${IPERF3_SEMANTIC_VERSION}_${ARCH_SUFFIX}.deb