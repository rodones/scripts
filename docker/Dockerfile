# Change according to CUDA support
ARG BASE_IMAGE
FROM $BASE_IMAGE

# Prevent stop building ubuntu at time zone selection.
ARG DEBIAN_FRONTEND=noninteractive

# Colmap build options
ARG CUDA_ENABLED=OFF

# Create user and group of the host
ARG USERNAME=rodones
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $USERNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $USERNAME

# Prepare and empty machine for building
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    vim \
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
    libcgal-qt5-dev

# Build and install ceres solver
RUN apt-get -y install \
    libatlas-base-dev \
    libsuitesparse-dev
RUN git clone https://github.com/ceres-solver/ceres-solver.git --branch 1.14.0
RUN cd ceres-solver && \
    mkdir build && \
    cd build && \
    cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF && \
    make -j4 && \
    make install

# Build and install COLMAP

# Note: This Dockerfile has been tested using COLMAP pre-release 3.6.
# Later versions of COLMAP (which will be automatically cloned as default) may
# have problems using the environment described thus far. If you encounter
# problems and want to install the tested release, then uncomment the branch
# specification in the line below
RUN git clone https://github.com/colmap/colmap.git #--branch 3.6

RUN cd colmap && \
    git checkout dev && \
    mkdir build && \
    cd build && \
    cmake .. -DCUDA_ENABLED=$CUDA_ENABLED && \
    make -j4 && \
    make install

# Install rodo dependencies
RUN apt-get -y install \
    python3 \
    python3-numpy

# Copy scripts and append them to PATH
COPY ./scripts /scripts
RUN chmod +x /scripts/*
ENV PATH="/scripts:${PATH}"
ENV LANG=C.UTF-8
ENV PYTHONPATH="/colmap/scripts/python/"