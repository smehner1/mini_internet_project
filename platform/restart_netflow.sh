#!/bin/bash


DIRECTORY=$(cd `dirname $0` && pwd)

ps -ef | grep "nfcapd -T +1,+4,+5,+10,+11,+13" | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep "fprobe -i" | grep -v grep | awk '{print $2}' | xargs kill

echo "netflow_start.sh: "
echo "netflow_start.sh $(($(date +%s%N)/1000000))" >> "${DIRECTORY}"/log.txt
rm -rf /home/max/WORK/masterthesis/mini_internet/router_files/netflow_mini-internet/*
time ./setup/netflow_start.sh "${DIRECTORY}"