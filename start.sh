#!/usr/bin/env bash

ORG="rodones"
NAME="colmap"
VERSION="gpu-latest"

SCRIPTS_DIR="./docker/scripts"
VOCAB_TREES_DIR="./docker/vocab-trees"

WORK_DIR=""
IS_TTY=0
COND_ARGS=()

print_help() {
    cat <<EOF
$PROG_NAME [OPTION...] FOLDER
Rodones COLMAP structure-from-motion script
Options:
  Hardware:
    -c, --cpu                     use cpu instead of gpu. $([ "$USE_GPU" = "0" ] && echo "(default)")
    -g, --gpu                     use gpu with cuda toolkit. $([ "$USE_GPU" = "1" ] && echo "(default)")
    -t, --thread=N                use N threads if possible.
  Matchers:
    -e, --exhaustive              use exhaustive matcher (default).
    -s, --sequential              use sequential matcher.
    -v, --vocab-tree=VT           use vocabulary tree matcher.
  
  -x, --exec=STEP...              only execute given steps.
EOF
}

if ! OPTIONS=$(getopt -n "$PROG_NAME" \
    -o hcgt \
    -l help,cpu,gpu,tty \
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
        USE_GPU=0
        VERSION="cpu-latest"
        ;;
    -g | --gpu)
        USE_GPU=1
        VERSION="gpu-latest"
        ;;
    -t | --tty)
        IS_TTY=1
        ;;
    *)
        [ -n "$WORK_DIR" ] && echo "error: multiple workspaces are not allowed." && exit 1
        
        WORK_DIR="$1"
        ;;
    esac
    shift
done

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

if [ "$IS_TTY" -eq 0 ]; then
    COND_ARGS+=("-e" "DISPLAY" "-v" "/tmp/.X11-unix:/tmp/.X11-unix")
fi

docker run \
    --rm \
    "${COND_ARGS[@]}" \
    --user="$(id --user):$(id --group)" \
    --privileged \
    --gpus all \
    -w /working \
    -v "$(realpath "$WORK_DIR"):/working" \
    -v "$(realpath "$SCRIPTS_DIR"):/scripts" \
    -v "$(realpath "$VOCAB_TREES_DIR"):/vocab-trees" \
    --env-file .env \
    --env WORKSPACE_NAME="$(basename "$WORK_DIR")" \
    -it "$ORG/$NAME:$VERSION"
