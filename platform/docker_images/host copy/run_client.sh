#!/bin/bash

ROUTER=$1
AS=$2
PORT=$3

# docker exec -ti ${AS}_${ROUTER}host bash -c "/usr/local/harpoon/run_harpoon.sh -v10 -w300 -f /harpoon/configs/${ROUTER}_client_config_${PORT}.xml"

/usr/local/harpoon/run_harpoon.sh -v10 -w300 -f /harpoon/configs/${ROUTER}_client_config_${PORT}.xml
