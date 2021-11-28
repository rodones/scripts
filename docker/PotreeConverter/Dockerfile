FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    git \
    libboost-all-dev \
    libtbb-dev \
    cloudcompare

RUN git clone https://github.com/LASzip/LASzip.git /tmp/LASzip && \
    cd /tmp/LASzip && \
    mkdir build && cd build && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr && \
    make && make install && ldconfig && \
    rm -rf /tmp/LASzip 

RUN git clone https://github.com/potree/PotreeConverter /tmp/PotreeConverter; \
    cd /tmp/PotreeConverter && \ 
    mkdir build && \
    cd build && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr; \
    make && \
    mkdir /opt/PotreeConverter && \
    cp -r Converter/ resources/ liblaszip.so PotreeConverter /opt/PotreeConverter && \
    rm -rf /tmp/PotreeConverter