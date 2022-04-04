#!/bin/bash

SLEEP=86400 # 1 day = 24* 60 *60
AFTER_DAYS=2

WEBSERVER_LOCATION="/var/www/html"

while true
do
    for i in netflow bgpdump; do
        echo "delete old $i data"
        find $WEBSERVER_LOCATION/$i/ -maxdepth 10 -type f  -mtime +$AFTER_DAYS 
        find $WEBSERVER_LOCATION/$i/ -maxdepth 10 -type f  -mtime +$AFTER_DAYS -delete
        echo
    done

    echo "sleep for $SLEEP seconds"
    sleep $SLEEP
done