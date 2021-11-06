# scripts

This repository contains custom scripts, docker files, etc. 

## Setup

### Requirements
- nvidia-docker (docker if cuda won't be used)
- ansible
    - community.docker
- terraform
- s3cmd
- ffmpeg

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
