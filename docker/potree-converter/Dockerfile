FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    git \
    libboost-all-dev

RUN git clone https://github.com/LASzip/LASzip.git; \
    cd LASzip; \
    mkdir build && cd build; \
    cmake .. \
        -DCMAKE_BUILD_TYPE="Release" \
        -DCMAKE_INSTALL_PREFIX=/usr; \
    make && make install && ldconfig; \
    cd /; \
    rm -rf LASzip

RUN mkdir /PotreeConverter

RUN apt-get update && apt-get install -y --no-install-recommends \
    libtbb-dev

RUN git clone https://github.com/potree/PotreeConverter /PotreeConverter; \
    cd /PotreeConverter && mkdir build && cd build; \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DLASZIP_INCLUDE_DIRS=/usr/include/laszip \
        -DLASZIP_LIBRARY=/usr/lib/liblaszip.so \
        -DCMAKE_INSTALL_PREFIX=/usr; \
    make

RUN apt-get update && apt-get install -y --no-install-recommends \
    cloudcompare
