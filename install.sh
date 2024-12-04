#!/bin/bash

# Update package list
apt update

# Install required packages
apt install -y unzip build-essential cmake libboost-all-dev libhdf5-mpi-dev libmetis-dev libjpeg-dev libx11-dev

#To root
cd /root

# Download and install Kokkos
KOKKOS_VERSION="4.5.00"
KOKKOS_URL="https://github.com/kokkos/kokkos/releases/download/${KOKKOS_VERSION}/kokkos-${KOKKOS_VERSION}.zip"
wget ${KOKKOS_URL} -O kokkos.zip
unzip kokkos.zip
cd kokkos-${KOKKOS_VERSION}
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=/usr/local/kokkos \
          -DKokkos_ENABLE_OPENMP=ON \
          -DKokkos_ENABLE_CUDA=ON \
          -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
make install
cd /root
rm -rf ./kokkos-${KOKKOS_VERSION}

# Download and set up GKG
GKG_URL="https://framagit.org/cpoupon/gkg/-/archive/master/gkg-master.zip"
wget ${GKG_URL} -O gkg.zip
unzip gkg.zip
cd gkg-master
mkdir build
cd build
