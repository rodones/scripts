FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    g++ \
    git \
    make \
    libjpeg-dev \
    libpng-dev \
    zlib1g-dev

RUN git clone https://github.com/mkazhdan/PoissonRecon.git /tmp/PoissonRecon && \
    cd /tmp/PoissonRecon && \
    make all;

RUN mkdir /opt/PoissonRecon && \
    find /tmp/PoissonRecon -perm /a+x -type f  -exec cp {} /opt/PoissonRecon \; && \
    rm -rf /tmp/PoissonRecon;

ENV PATH="/opt/PoissonRecon:${PATH}"
