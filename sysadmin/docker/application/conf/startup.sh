#!/bin/sh

if [ $# -eq 0 ]; then
    apache2-foreground
else
    exec "$@"
fi
