# scripts

This repository contains custom scripts, docker files, etc. 

## Usage

- Build colmap [docker](./docker) images.

- Create `.env` using [.env.example](./.env.example).

- Start interactive session using [./start.sh](./start.sh).

      ./start.sh WORKSPACE [--gpu | --cpu]

- Execute scripts using `rodo` in the container.
  - Type `rodo --help` to see available scripts.
  - Note: If you don't want logging and notification, skip this.

## Video to Image Convertion

- Install `ffmpeg`.

- Run `vid2img.sh` with input file and output folder, and optionally fps (default is 1 which means 1 frame per 1 second). (Example `./vid2img.sh ./VID_20210910_093215.mp4 ./images/ 5`)