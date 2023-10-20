#! /bin/bash

# Author: Max Bergmann

ASES=$1
date=$(date +%m-%d-%Y-%T)

MEM=$(free --human | grep "Mem" | awk '{print $3}')
CPU=$(top -bn2 | awk '/Cpu/ { print $2}' | tail -1)

mem=${MEM%.*}
mem=${mem%G*}

if [ $mem -ge 90 ]; then
    echo "MEMORY LIMIT REACHED --> STOP THIS SCALE"
    ps -ef | grep scalability_run.sh | grep -v grep | awk '{print $2}' | xargs kill
    ps -ef | grep generate_day_traffic.sh | grep -v grep | awk '{print $2}' | xargs kill
    ps -ef | grep netflow_collector.py | grep -v grep | awk '{print $2}' | xargs kill
fi

echo "${ASES},${date},${MEM%G*},${CPU}" >> ressources_log.log
