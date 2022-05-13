#!/bin/bash

MAIL_ADDRESS="stefan.mehner@b-tu.de"
THRESHOLD=60
inode_usage=$(cat stats/disk_usage.csv | tail -n 1 | awk '{print $NF}')

mail_text_file="/tmp/inode_mail_text.txt"

if [[ $inode_usage -gt $THRESHOLD ]]; then
    echo "Subject: Mini Internet inode usage exceeds $THRESHOLD% - ACTION REQUIRED!" > $mail_text_file
    echo "Login at mini internet and watch the following directiories" >> $mail_text_file
    echo ' - /var/www/html/netflows' >> $mail_text_file
    echo ' - /var/www/bgpdumps' >> $mail_text_file
    echo ' - router docker containers' >> $mail_text_file
    echo $mail_text_file
    sendmail $MAIL_ADDRESS < $mail_text_file
fi
echo
echo "inodes checked - sleep 1 day"
sleep 86400 # 1day