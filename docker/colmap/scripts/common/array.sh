#!/usr/bin/env bash

array_contains() {
    local -rn array="$1"
    local value="$2"

    if [[ ! " ${array[*]} " == *" ${value} "* ]]; then
        return 1
    fi

    return 0
}

array_typeof() {
    local -rn array="$1"
    local -rn valid_values="$2"

    for i in "${!array[@]}"; do
        if [[ ! " ${valid_values[*]} " == *" ${array[i]} "* ]]; then
            return $(("$i" + 1))
        fi
    done

    return 0
}