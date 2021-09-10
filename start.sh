#!/usr/bin/env sh

WORK_DIR="$1"
VARIANT="${2:---gpu}"
ORG="rodones"
NAME="colmap"
VERSION="latest"
SCRIPTS_DIR="./docker/scripts"

if [ -z "$WORK_DIR" ]; then
	echo "error: working directory is not specified."
	exit 1
elif [ ! -d "$WORK_DIR" ]; then
	echo "error: working directory does not exist."
	exit 2
elif [ ! -d "$WORK_DIR/images" ]; then
	echo "error: the directory is not working directory. ensure that it has images folder."
	exit 3
fi

if [ "$VARIANT" = "--gpu" ]; then
	VERSION="gpu-$VERSION"
elif [ "$VARIANT" = "--cpu" ]; then
	VERSION="cpu-$VERSION"
else
	echo "error: invalid parameter. expected --cpu or --gpu."
	exit 4
fi

docker run \
	--name "colmap$VARIANT" \
	--rm -e DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	--user="$(id --user):$(id --group)" \
	--privileged \
	--gpus all \
	-w /working \
	-v "$(realpath "$WORK_DIR"):/working" \
	-v "$(realpath "$SCRIPTS_DIR"):/scripts" \
	-it "$ORG/$NAME:$VERSION"
