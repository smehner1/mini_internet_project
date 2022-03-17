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

echo $WEBSERVER_LOCATION

sudo mkdir -p  $WEBSERVER_LOCATION/netflow/
while true
do
    for ((k=0;k<group_numbers;k++)); do
        group_k=(${groups[$k]})
        group_number="${group_k[0]}"
        group_as="${group_k[1]}"
        group_config="${group_k[2]}"
        group_router_config="${group_k[3]}"
    
	#uplaod
	if [ "${group_as}" == "IXP" ];then
        # create folder at webserver if not existing 
        mkdir -pv $WEBSERVER_LOCATION/netflow/G"${group_number}"

        #rsync -a groups/g"${group_number}"/netflow/* $WEBSERVER_LOCATION/netflow/G$group_number/ || true

        # e.g. 83_IXP
        docker cp "${group_number}"_"IXP":/home/netflow/. $WEBSERVER_LOCATION/netflow/G"${group_number}"/ 
	    #find groups/g"${group_number}"/netflow -type f -mtime +1 -delete
	else
	    readarray routers < config/$group_router_config
            n_routers=${#routers[@]}

            for ((i=0;i<n_routers;i++)); do
                router_i=(${routers[$i]})
                rname="${router_i[0]}"
		        location=groups/g"${group_number}"/"${rname}"

                # create folder at webserver if not existing 
                mkdir -pv $WEBSERVER_LOCATION/netflow/G"${group_number}"/"${rname}"/ 
  
    		    #rsync -a "${location}"/netflow/*  $WEBSERVER_LOCATION/netflow/G"${group_number}"/"${rname}"/ || true
                # e.g. 1_GENErouter or 2_MIAMrouter
                docker cp "${group_number}"_"${rname}"router:/home/netflow/. $WEBSERVER_LOCATION/netflow/G"${group_number}"/"${rname}"/ 

		        #find "${location}"/netflow/ -type f -mtime +1 -delete
            done
	fi

        # modify owner
        chown -R www-data:www-data $WEBSERVER_LOCATION/netflow/
        find $WEBSERVER_LOCATION/netflow/ -type d -exec chmod 755 {} \;
        find $WEBSERVER_LOCATION/netflow/ -type f -exec chmod 644 {} \;

        echo INFO: processing
        #process
        for file in $(find $WEBSERVER_LOCATION/netflow/G"${group_number}"/ -type f ! -name "*.txt" ! -name "*.gz" ! -name "*current*"); do
                echo $file
                if [ ! -f "${file}".txt ]; then
			        touch ${file}.txt
			        touch ${file}.csv.gz
    			    chmod ugo+r -R ${file} ${file}.txt ${file}.csv.gz
                    nfdump -r "${file}" -o csv | gzip -9 > "${file}".csv.gz &
			        nfdump -r "${file}" -o line > "${file}".txt &
                fi
        done
        wait

        echo $group_number done
    done
    sleep 60
done
