# COLMAP container

## Usage

- Pull from [Docker Hub](https://hub.docker.com/r/rodones/colmap) or build the [docker](./docker) image.
  - cpu-latest for no cuda support,
  - gpu-latest for cuda support.

- Start interactive session using [./start.sh](./start.sh).

      ./start.sh WORKSPACE [[--gpu | --cpu] | --tty]

- Execute scripts using `rodo` in the container.
  - Type `rodo --help` to see available scripts.
  - Note: If you don't want logging and notification, skip this. colmap binaries are in the PATH.

## Available Scripts

The scripts placed in [this](https://github.com/rodones/workspace/tree/master/docker/colmap/scripts) folder are available to run directly. 
- rodo
- sfm
- mvs
- images
- list-keypoints
- draw-keypoints 
