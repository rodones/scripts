# scripts

This repository contains custom scripts, docker files, etc. 

## Usage

- Build colmap [docker](./docker) images.

- Create `data` folder and put your images into it.

      mkdir data

- Start interactive session using [./start.sh](./start.sh).

      ./start.sh WORKSPACE [--gpu | --cpu]

- Execute scripts using rodo in the container.
  - Type `rodo --help` to see available scripts.
