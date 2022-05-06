# scripts

This repository contains custom scripts, docker files, etc. 

## Documents

- [Video to Image Convertion](docs/converting-video-to-images.md)
- [Executing s4cmd commands parallel](docs/s4cmd-parallel-parallel-execution.md)
- [Uploading Images to S3 Compatible Service](docs/uploading-images.md)

## Setup

### Requirements

#### Host System
- Docker Engine
    - [docker](https://docs.docker.com/engine/install/ubuntu/) (If CUDA is not enabled)
    - [nvidia-docker](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) (If CUDA enabled)

#### Automated Instance Creation
- [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW)
    - [community.docker](https://docs.ansible.com/ansible/latest/collections/community/docker/index.html)
- [terraform](https://www.terraform.io/downloads)

#### Miscellaneous

##### vid2img.sh
- [ffmpeg](https://ffmpeg.org/download.html)

##### sync.sh
- [s4cmd](https://github.com/bloomreach/s4cmd)

### Configuration
- Create `.env` using [.env.example](./.env.example) and fill. This will be used by  [start.sh](./start.sh) for 
container identification and notification purposes.
- Create `digitalocean.auto.tfvars` using [.env.example](./terraform/digitalocean.auto.example.tfvars). This will be
used for remote server creation on digitalocean.  

## Building and Pulling Images

Building process is described [here](./docker). 

The prebuilt images are published in [Docker Hub](https://hub.docker.com/repository/docker/rodones/colmap).

## Usage

- Pull or build the [docker](./docker) image.

- Start interactive session using [./start.sh](./start.sh).

      ./start.sh WORKSPACE [[--gpu | --cpu] | --tty]

- Execute scripts using `rodo` in the container.
  - Type `rodo --help` to see available scripts.
  - Note: If you don't want logging and notification, skip this.
