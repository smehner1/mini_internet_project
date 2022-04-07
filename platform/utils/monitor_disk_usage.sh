#!/bin/bash

LOG_FILE="./stats/disk_usage.csv"

SLEEP=86400 # 1 day = 24* 60 *60
DEVICE="/var/www/html"
DATE_FORMAT="%Y-%m-%d" #_%H-%M-%S" 

while true
do
    echo "get inode and disk usage"

    current_date=$(date +$DATE_FORMAT)
    disk_usage=$(df $DEVICE | tail -1 | awk '{print $5}' | sed 's|%||')
    inode_usage=$(df -i $DEVICE | tail -1 | awk '{print $5}' | sed 's|%||')

    echo "$current_date $disk_usage $inode_usage" >> "$LOG_FILE"

    ./utils/plot_disk_usage.py
    sudo chown www-data:www-data /var/www/html/stats/disk_usage.png

    echo "sleep"
    sleep $SLEEP
done