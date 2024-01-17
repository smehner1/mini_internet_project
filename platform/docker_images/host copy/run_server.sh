#!/bin/bash

ROUTER=$1
AS=$2
PORT=$3
P=$4

# docker exec -ti ${AS}_${ROUTER}host bash -c "/usr/local/harpoon/run_harpoon.sh -v10 -w300 -p 818${P} -l /harpoon/logs/server_${PORT}.log -c -f /harpoon/configs/${ROUTER}_server_config_${PORT}.xml"

/usr/local/harpoon/run_harpoon.sh -v10 -w300 -p 818${P} -l /harpoon/logs/server_${PORT}.log -c -f /harpoon/configs/${ROUTER}_server_config_${PORT}.xml
