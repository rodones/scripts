# ============================================================
# BUILD STAGE
# ============================================================

# Change according to CUDA support
ARG BASE_IMAGE
ARG BASE_IMAGE_BUILD
FROM $BASE_IMAGE_BUILD AS builder

# Prevent stop building ubuntu at time zone selection.
ARG DEBIAN_FRONTEND=noninteractive

# Colmap build options
ARG CUDA_ENABLED=OFF

# Install build dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libboost-test-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libfreeimage-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libcgal-qt5-dev \
    libatlas-base-dev \
    libceres-dev

# Build COLMAP
RUN git clone https://github.com/colmap/colmap.git
RUN cd colmap && \
    git checkout dev && \
    mkdir build && \
    cd build && \
    cmake .. -DCUDA_ENABLED=$CUDA_ENABLED && \
    make -j4 && \
    make install

# ============================================================
# WORKSPACE STAGE
# ============================================================

FROM $BASE_IMAGE

# Install colmap dependencies
RUN apt-get update && apt-get install -y \
    libglew2.0 \
    libfreeimage3 \
    libgoogle-glog0v5 \
    libceres1 \
    libopengl0 \
    libqt5widgets5 \
    libcgal13 \
    libgl1

# Install rodo dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-numpy \
    python3-pil \
    curl \
    s3cmd

# Copy colmap binary and scripts
COPY --from=builder /colmap/build/src/exe/colmap /usr/bin/colmap
COPY --from=builder /colmap/scripts /colmap/scripts

# Create user and group of the host
ARG USERNAME=rodones
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $USERNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $USERNAME

# Copy scripts and append them to PATH
COPY ./scripts /scripts
RUN chmod +x /scripts/*

ENV PATH="/scripts:${PATH}" \ 
    LANG="C.UTF-8" \
    PYTHONPATH="/colmap/scripts/python/:/scripts"

RUN echo 'export PS1="($WORKSPACE_NAME) $PS1"' >> "/home/$USERNAME/.bashrc"
