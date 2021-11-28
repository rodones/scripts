FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    cmake \
    build-essential \
    ca-certificates \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev

RUN git clone https://github.com/cnr-isti-vclab/vcglib.git /tmp/vcglib && \
    git clone https://github.com/cnr-isti-vclab/nexus.git /tmp/nexus && \
    cd /tmp/nexus && \
    git submodule init && \
    git submodule update && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j8

RUN mkdir /opt/nexus && \
    find /tmp/nexus -perm /a+x -type f  -exec cp {} /opt/nexus \; && \
    rm -rf /tmp/nexus;

ENV PATH="/opt/nexus:${PATH}"
