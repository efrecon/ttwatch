#!/bin/sh

set -e

# Default to ttwatchd whenever no arg or starting with an option, e.g. a dash.
if [ "$#" -eq "0" ] || [ "${1#-}" != "$1" ]; then
    set -- ttwatchd "$@"
fi

exec "$@"