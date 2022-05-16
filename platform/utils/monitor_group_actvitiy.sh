#!/bin/bash
#
DATE_FORMAT="%Y-%m-%d" #_%H-%M-%S" 
SLEEP=86400 # 1 day = 24* 60 *60

LOG_FILE_hist="./stats/group_activity_hist_loc.csv"
LOG_FILE_login="./stats/group_activity_login_count.csv"
LOG_FILE_dur="./stats/group_activity_login_duration.csv"


mkdir -p "./stats"
set -o errexit
set -o pipefail
set -o nounset

# read configs
readarray groups < config/AS_config.txt
group_numbers=${#groups[@]}

WEBSERVER_LOCATION="/var/www/html"
#rm $LOG_FILE_hist
#rm $LOG_FILE_dur
#rm $LOG_FILE_login


while true
do
    current_date=$(date +$DATE_FORMAT)
    echo -n "$current_date" >> $LOG_FILE_hist
    echo -n "$current_date" >> $LOG_FILE_dur
    echo -n "$current_date" >> $LOG_FILE_login

    echo "get LOCs from ssh container of each group"
    for ((k=0;k<group_numbers;k++)); do
          group_k=(${groups[$k]})
          group_number="${group_k[0]}"
          group_as="${group_k[1]}"
          group_config="${group_k[2]}"
          group_router_config="${group_k[3]}"

      #mkdir -p $WEBSERVER_LOCATION/bgpdump/G$group_number

      # echo "${group_number}"
      if [ "${group_config}" == "NoConfig" ];then
        sudo docker exec "${group_number}"_ssh touch /root/.bash_history
        hist_len=$(sudo docker exec "${group_number}"_ssh cat /root/.bash_history 2> /dev/null | wc -l)
        dur=$(sudo docker exec "${group_number}"_ssh last 2> /dev/null |grep -v "wtmp begins" | awk '{print $NF}' |sed 's|[()]||g' |awk 'FS=":" {hours+=$1; minutes+=$1} END{ minutes+=hours*60;  print minutes; }') 
        login_count=$(sudo docker exec "${group_number}"_ssh last 2> /dev/null |grep -v "wtmp begins" |wc -l)
        echo -n " $hist_len" >> $LOG_FILE_hist
        echo -n " $dur" >> $LOG_FILE_dur
        echo -n " $login_count" >> $LOG_FILE_login
        

      fi
    done

    ./utils/plot_group_activity.py
    sudo chown www-data:www-data /var/www/html/stats/group_activity.png


    echo >> $LOG_FILE_hist
    echo >> $LOG_FILE_dur
    echo >> $LOG_FILE_login
    
    echo "sleep"
    sleep $SLEEP
done
