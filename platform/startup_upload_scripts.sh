#!/bin/bash


### start ping.py in matrix container
echo "start ping.py script in matrix docker container"
sudo docker exec MATRIX tmux new-session -d -s ping 'cd /home; python ping.py'
echo
### start matrix upload script in screen

echo "start screen sessions"
for serv in upload_matrix upload_looking_glass upload_netflows upload_bgpdumps; do 
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

### add cronjob to automatically commit changes in matrix

# we have a cronjob that commits the matrix html page
# Oliver has a repo running at /scratch/matrix_monitor
# Stefan also wrote a mini script at `utils/commit_matrix.sh``
#   ​sudo crobtab -e 
#  ​0 6 * * * bash /scratch/mini-internet/platform/utils/commit_matrix.sh


### delete netflow and bgpdump data that are older than x days
# find /path/to/files* -mtime +5 -exec rm {} \;