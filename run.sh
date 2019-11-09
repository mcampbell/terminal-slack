#!/bin/bash

if [ -n "$BASH" ]; then
    set -o pipefail

    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        HERE="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$HERE/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    HERE="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"


elif [ -n "$ZSH_NAME" ]; then
    HERE="${0:A:h}"
fi

function log() {
    echo $(date +%Y.%m.%d-%H.%M.%S):$$ $*
}

set -eu

THISBIN="$(basename $0)"
NOW=$(date +%Y-%m-%dT%H:%M:%S)
TIMESTAMP=$(date +%Y-%m-%d.%H-%M-%S)

log Starting.

function cleanup() {
    log Ending.
    echo
}

trap cleanup EXIT

cd "$HERE"

if [ ! -f "$HERE"/slack.env ]; then
    echo This requires a file in "$HERE" named slack.env, which exports the SLACK_TOKEN value.
    echo Exiting.
    exit 2
fi

source "$HERE"/slack.env

node ./main.js
