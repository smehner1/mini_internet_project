#!/bin/bash

WEBSERVER_LOCATION="/var/www/html"

mkdir -p $WEBSERVER_LOCATION/matrix

### start ping.py in matrix container
echo "start ping.py script in matrix docker container"
if [ -n "$(sudo docker exec MATRIX tmux list-sessions | grep ping)" ]; then
    sudo docker exec MATRIX tmux kill-session -t ping
fi
sudo docker exec MATRIX tmux new-session -d -s ping 'cd /home; python ping.py'
echo

while true
do
    docker cp MATRIX:/home/matrix.html $WEBSERVER_LOCATION/matrix/index.html
    
    # adjust rights
    chown www-data:www-data $WEBSERVER_LOCATION/matrix/index.html
    find $WEBSERVER_LOCATION/matrix/ -type d -exec chmod 755 {} \;
    find $WEBSERVER_LOCATION/matrix/ -type f -exec chmod 644 {} \;
    echo 'matrix sent'
    sleep 10

done
