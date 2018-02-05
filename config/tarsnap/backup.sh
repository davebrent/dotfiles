#!/bin/sh
/usr/bin/tarsnap -c \
    --print-stats \
    --configfile /home/dave/.tarsnaprc \
    -f "$(uname -n)-$(date +%Y-%m-%d_%H-%M-%S)" \
    /home/dave/Workspace
