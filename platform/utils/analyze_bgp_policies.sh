#!/bin/bash

WEBSERVER_LOCATION="/var/www/html"
POLICY_ANALYZER_FOLDER="./utils/bgp_policy_analyzer"

python3 $POLICY_ANALYZER_FOLDER/cfparse.py ./config/

while true
do
    python3 $POLICY_ANALYZER_FOLDER/lgparse.py ./groups/
    python3 $POLICY_ANALYZER_FOLDER/lganalyze.py print-html > $WEBSERVER_LOCATION/analysis.html
    chown -R www-data:www-data $WEBSERVER_LOCATION/analysis.html

    #scp analysis.html thomahol@virt07.ethz.ch:/home/web_commnet/public_html/routing_project/bgp_analyzer/
    echo 'html file sent'
    sleep 120
done
