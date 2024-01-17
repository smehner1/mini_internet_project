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

while true
do
    for ((k=0;k<group_numbers;k++)); do
        group_k=(${groups[$k]})
        group_number="${group_k[0]}"
        group_as="${group_k[1]}"
        group_config="${group_k[2]}"
        group_router_config="${group_k[3]}"

        mkdir -p $WEBSERVER_LOCATION/looking_glass/G$group_number
        
        if [ "${group_as}" != "IXP" ];then

            readarray routers < config/$group_router_config
            n_routers=${#routers[@]}

            for ((i=0;i<n_routers;i++)); do
                router_i=(${routers[$i]})
                rname="${router_i[0]}"
                property1="${router_i[1]}"
                property2="${router_i[2]}"

		        cp groups/g${group_number}/${rname}/looking_glass.txt $WEBSERVER_LOCATION/looking_glass/G$group_number/${rname}.txt

                echo $group_number $rname
            done
	    else
	        cp groups/g${group_number}/looking_glass.txt $WEBSERVER_LOCATION/looking_glass/G$group_number/IXP.txt
        fi

        chown -R www-data:www-data $WEBSERVER_LOCATION/looking_glass/
        find $WEBSERVER_LOCATION/looking_glass/ -type d -exec chmod 755 {} \;
        find $WEBSERVER_LOCATION/looking_glass/ -type f -exec chmod 644 {} \;
        echo $group_number done
    done
    sleep 60
done
