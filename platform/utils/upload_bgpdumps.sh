#!/bin/bash
#
# Upload the looking glass on a web server

# REQUIREMENT: make sure to upload you public in the remote server where you
# want to upload the looking glass. And change the username when doing the scp.

set -o errexit
set -o pipefail
set -o nounset

# read configs
readarray groups < config/AS_config.txt
group_numbers=${#groups[@]}

WEBSERVER_LOCATION="/var/www/html"
bgpdump_folder="/home/bgpdump"

while true
do
    for ((k=0;k<group_numbers;k++)); do
        group_k=(${groups[$k]})
        group_number="${group_k[0]}"
        group_as="${group_k[1]}"
        group_config="${group_k[2]}"
        group_router_config="${group_k[3]}"

    mkdir -p $WEBSERVER_LOCATION/bgpdump/G$group_number

	#upload
	if [ "${group_as}" == "IXP" ];then
        mkdir -pv $WEBSERVER_LOCATION/bgpdump/G"${group_number}"

        echo "${group_number}"_"IXP"
        docker cp "${group_number}"_"IXP":$bgpdump_folder/. $WEBSERVER_LOCATION/bgpdump/G"${group_number}"/ 
        #docker exec "${group_number}"_"IXP" mkdir -p $bgpdump_folder; rm -rf $bgpdump_folder; mkdir -p $bgpdump_folder;
	    
        #rsync -a groups/g"${group_number}"/bgpdump/* $WEBSERVER_LOCATION/bgpdump/G"${group_number}"/ || true
	    #find groups/g"${group_number}"/bgpdump -type f -mtime +1 -delete
	else
	    readarray routers < config/$group_router_config
            n_routers=${#routers[@]}

            for ((i=0;i<n_routers;i++)); do
                router_i=(${routers[$i]})
                rname="${router_i[0]}"
        		location=groups/g"${group_number}"/"${rname}"

                # create folder at webserver if not existing 
                mkdir -pv $WEBSERVER_LOCATION/bgpdump/G"${group_number}"/"${rname}"/ 

                echo "${group_number}"_"${rname}"router
                docker cp "${group_number}"_"${rname}"router:$bgpdump_folder/. $WEBSERVER_LOCATION/bgpdump/G"${group_number}"/"${rname}"/ 
                #docker exec "${group_number}"_"${rname}"router mkdir -p $bgpdump_folder; rm -rf $bgpdump_folder; mkdir -p $bgpdump_folder;
    	    	#rsync -a "${location}"/bgpdump/* $WEBSERVER_LOCATION/bgpdump/G"${group_number}"/"${rname}"/ || true
		        #find "${location}"/bgpdump/ -type f -mtime +1 -delete
            done
	fi

    chown -R www-data:www-data $WEBSERVER_LOCATION/bgpdump/

	#processing
        for file in $(find $WEBSERVER_LOCATION/bgpdump/G"${group_number}"/ -type f ! -name "*.txt"); do
                # echo $file
                if [ ! -f "${file}".txt ]; then
			        touch ${file}.txt
    			    chmod ugo+r -R ${file} ${file}.txt
                    bgpdump "${file}" > "${file}".txt &
                fi
        done
        wait

        echo $group_number done
    done
    sleep 60
done
