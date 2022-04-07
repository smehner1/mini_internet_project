#!/bin/bash
#
DATE_FORMAT="%Y-%m-%d" #_%H-%M-%S" 
SLEEP=86400 # 1 day = 24* 60 *60

LOG_FILE="./stats/user_activity.csv"
mkdir -p "./stats"
set -o errexit
set -o pipefail
set -o nounset

# read configs
readarray groups < config/AS_config.txt
group_numbers=${#groups[@]}

WEBSERVER_LOCATION="/var/www/html"


while true
do
    current_date=$(date +$DATE_FORMAT)
    echo -n "$current_date" >> $LOG_FILE

    echo "get LOCs from ssh container of each group"
    for ((k=0;k<group_numbers;k++)); do
          group_k=(${groups[$k]})
          group_number="${group_k[0]}"
          group_as="${group_k[1]}"
          group_config="${group_k[2]}"
          group_router_config="${group_k[3]}"

      mkdir -p $WEBSERVER_LOCATION/bgpdump/G$group_number

      # echo "${group_number}"
      if [ "${group_config}" == "NoConfig" ];then
        sudo docker exec "${group_number}"_ssh touch /root/.bash_history
        hist_len=$(sudo docker exec "${group_number}"_ssh cat /root/.bash_history 2> /dev/null | wc -l)
        echo -n " $hist_len" >> $LOG_FILE

      fi
    done

    ./utils/plot_group_activity.py
    sudo chown www-data:www-data /var/www/html/stats/group_activity.png


    echo >> $LOG_FILE
    echo "sleep"
    sleep $SLEEP
done
