#!/usr/bin/env bash

PROG_NAME="$(basename "$0")"

ORG="rodones"
NAME="colmap"
VERSION="gpu-latest"

SCRIPTS_DIR="./docker/colmap/scripts"
VOCAB_TREES_DIR="./docker/colmap/vocab-trees"

WORK_DIR=""
IS_TTY=1
VARIANT="gpu"
ARGS=()
DOCKER_COND_ARGS=()

print_help() {
    cat <<EOF
$PROG_NAME [OPTION...] FOLDER [CMD]
Rodones Docker starter
Options:
  -c, --cpu                     use cpu variant
  -g, --gpu                     use gpu variant
  -d, --dev                     use development variant
  -T, --no-tty                  disable tty
EOF
}

if ! OPTIONS=$(getopt -n "$PROG_NAME" \
    -o hcgdT \
    -l help,cpu,gpu,dev,no-tty \
    -- "$@"); then
    exit
fi

eval set -- "$OPTIONS"

while [ $# -gt 0 ]; do
    case $1 in
    -h | --help)
        print_help
        exit
        ;;
    -c | --cpu)
        VARIANT="cpu"
        ;;
    -g | --gpu)
        VARIANT="gpu"
        ;;
    -d | --dev)
        VARIANT="dev"
        ;;
    -T | --no-tty)
        IS_TTY=0
        ;;
    *)
        ARGS+=("$1")
        ;;
    esac
    shift
done

WORK_DIR="${ARGS[1]}"
CMD=("${ARGS[@]:2}")

if [ -z "$WORK_DIR" ]; then
    echo "error: working directory is not specified."
    exit 2
elif [ ! -d "$WORK_DIR" ]; then
    echo "error: working directory does not exist."
    exit 3
elif [ ! -d "$WORK_DIR/images" ]; then
    echo "error: the directory is not working directory. ensure that it has images folder."
    exit 4
fi

if [ "$VARIANT" == "gpu" ]; then
    VERSION="gpu-latest"
    DOCKER_COND_ARGS+=("--gpus" "all")
elif [ "$VARIANT" == "cpu" ]; then
    VERSION="cpu-latest"
elif [ "$VARIANT" == "dev" ]; then
    VERSION="test"
fi

if [ "$IS_TTY" -eq 1 ]; then
    DOCKER_COND_ARGS+=("-e" "DISPLAY" "-v" "/tmp/.X11-unix:/tmp/.X11-unix" "-t")
fi

docker run \
    --rm \
    "${DOCKER_COND_ARGS[@]}" \
    --user="$(id --user):$(id --group)" \
    --privileged \
    -w /working \
    -v "$(realpath "$WORK_DIR"):/working" \
    -v "$(realpath "$SCRIPTS_DIR"):/scripts" \
    -v "$(realpath "$VOCAB_TREES_DIR"):/vocab-trees" \
    --env-file .env \
    --env WORKSPACE_NAME="$(basename "$WORK_DIR")" \
    -i "$ORG/$NAME:$VERSION" \
    "${CMD[@]}"
