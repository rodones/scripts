# COLMAP Docker Image 

## With CUDA Support

Read [How to build COLMAP using Docker](https://github.com/colmap/colmap/tree/dev/docker) for requirements.

- Build image:

        $ ./build.sh --with-cuda

- Run container:

        $ docker run -it rodones/colmap:gpu-latest


## Without CUDA Support

- Build image:

        $ ./build.sh --without-cuda

- Run container:

        $ docker run -it rodones/colmap:cpu-latest