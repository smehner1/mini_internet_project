#!/bin/bash

KILL=0

if [ $1 == "kill" ]; then
   echo "kill only"
    KILL=1
fi

### start matrix upload script in screen

echo "delete old netflow, bgpdump and looking_glass data at webserver location"
sudo rm -Rf /var/www/html/netflow
sudo rm -Rf /var/www/html/bgpdump
sudo rm -Rf /var/www/html/looking_glass

echo "start screen sessions"

#  delete_old_nf_and_bgp 
for serv in upload_matrix upload_looking_glass upload_netflows upload_bgpdumps monitor_disk_usage connectivity_matrix_history monitor_group_actvitiy analyze_bgp_policies monitor_disk_usage_alert; do 
    if [ $KILL == 1 ]; then
        sudo screen -x $serv -X quit
    else

        if sudo screen -ls |grep -q $serv; then
            echo found $serv
        else
            echo $serv not found
            echo " - start $serv screen session"
            sudo screen -d -m -S $serv ./utils/$serv.sh 
        fi
    fi
done
echo

echo "running screen sessions"
echo "-----------------------"
sudo screen -list
echo "-----------------------"
echo

