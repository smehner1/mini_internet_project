#!/bin/bash

for i in $(sudo docker ps -a | awk '{print $NF}' |grep -e router -e ssh -e host); do 
    # echo "$i " 
    
    check_it=$(sudo docker exec $i touch /tmp | grep OCI)
    if [[  -n $check_it ]]; then
        echo "cannot acces $i -> restart"
        echo sudo docker kill $i
        echo sudo docker start $i
        echo sudo ./groups/restart_container.sh $i
        echo " ... done\n"
    fi
done

# 1_GENErouter 