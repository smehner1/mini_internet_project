#!/bin/bash


### start ping.py in matrix container
echo "start ping.py script in matrix docker container"
sudo docker exec MATRIX tmux new-session -d -s ping 'cd /home; python ping.py'
echo
### start matrix upload script in screen

echo "start screen sessions"
for serv in upload_matrix upload_looking_glass upload_netflows upload_bgpdumps delete_old_nf_and_bgp monitor_disk_usage; do 
    echo " - try to kill $serv session"
    sudo screen -x $serv -X quit

    echo " - start $serv screen session"
    sudo screen -d -m -S $serv ./utils/$serv.sh 
done
echo

echo "running screen sessions"
echo "-----------------------"
sudo screen -list
echo "-----------------------"
echo

