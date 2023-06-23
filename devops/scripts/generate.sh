#!/usr/bin/env bash

set -e

SCRIPT_PATH=$(dirname $0)

if [ "x$PARAM_MODE" == "xroot" ]; then
    source $SCRIPT_PATH/generate-root.sh
elif [ "x$PARAM_MODE" == "xproduct" ]; then
    source $SCRIPT_PATH/generate-product.sh
else
    echo "ERROR: current PARAM_MODE [$PARAM_MODE] is unsupported !" >&2; exit 1
fi
