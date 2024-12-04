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

: <<'END'
# Install Zlib
ZLIB_VERSION="1.3.1"
ZLIB_URL="https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz"
wget ${ZLIB_URL} -O zlib.tar.gz
tar -xzf zlib.tar.gz
cd zlib-${ZLIB_VERSION}
./configure --prefix=/usr/local/zlib
make -j$(nproc)
make install
cd /root
rm -rf ./zlib-${ZLIB_VERSION}

# Install Szip
SZIP_VERSION="2.1.1"
SZIP_URL="https://docs.hdfgroup.org/archive/support/ftp/lib-external/szip/${SZIP_VERSION}/src/szip-${SZIP_VERSION}.tar.gz"
wget ${SZIP_URL} -O szip.tar.gz
tar -xzf szip.tar.gz
cd szip-${SZIP_VERSION}
./configure --prefix=/usr/local/szip
make -j$(nproc)
make install
cd /root
rm -rf ./szip-${SZIP_VERSION}

# Install HDF5 (parallel version)
HDF5_VERSION="1.14.4-3"
HDF5_URL="https://github.com/HDFGroup/hdf5/releases/download/hdf5_1.14.4.3/hdf5-1.14.4-3.tar.gz"
wget ${HDF5_URL} -O hdf5.tar.gz
tar -xzf hdf5.tar.gz
cd hdf5-${HDF5_VERSION}
./configure -with-zlib=/usr/local/zlib --enable-parallel --enable-hl --enable-static --enable-shared --prefix=/usr/local/hdf5
make -j$(nproc)
make install
cd /root
rm -rf ./hdf5-${HDF5_VERSION}
END

# Download and set up GKG
GKG_URL="https://framagit.org/cpoupon/gkg/-/archive/master/gkg-master.zip"
wget ${GKG_URL} -O gkg.zip
unzip gkg.zip
cd gkg-master
mkdir build
cd build
