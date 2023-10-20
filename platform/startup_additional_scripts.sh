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

# for serv in upload_matrix upload_looking_glass upload_netflows upload_bgpdumps monitor_disk_usage connectivity_matrix_history monitor_group_actvitiy analyze_bgp_policies monitor_disk_usage_alert delete_old_nf_and_bgp; do 
for serv in collect_garbage monitor_inodes_docker monitor_disk_usage; do 
    if [ $KILL == 1 ]; then
        sudo screen -x $serv -X quit
    else

        echo
        echo $serv
        if sudo screen -ls |grep -q $serv; then
            echo found $serv
        else
            echo $serv not found
            echo " - start $serv screen session with ./utils/$serv.sh"
            sudo screen -d -m -S $serv bash -c "source ./utils/$serv.sh"
        fi
    fi
done
echo

echo "running screen sessions"
echo "-----------------------"
sudo screen -list
echo "-----------------------"
echo

