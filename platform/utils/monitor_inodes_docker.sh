#!/bin/bash

MAIL_ADDRESS="max.bergmann@b-tu.de"
# MAIL_ADDRESS2="maxbergi97@gmail.com"
THRESHOLD=80
mail_text_file="/tmp/inode_mail_text.txt"
mail_text_file2="/tmp/sda2disk_mail_text.txt"
mail_text_file3="/tmp/scratch_mail_text.txt"

while :
do
    inode_usage=$(df -i /var/lib/docker/ | tail -1 | awk '{print $5}' | sed 's|%||')
    disk_usage=$(df -h /dev/sda2 | tail -1 | awk '{print $5}' | sed 's|%||')
    scratch_usage=$(df -h /scratch/ | tail -1 | awk '{print $5}' | sed 's|%||')
    echo $inode_usage
    echo $disk_usage

    if [ $inode_usage -gt $THRESHOLD ]; then
        echo "Subject: Docker inode usage exceeds ${THRESHOLD}% - ACTION REQUIRED!" > $mail_text_file
        echo "" >> $mail_text_file
        echo "current inode usage: ${inode_usage}%" >> $mail_text_file
        echo "" >> $mail_text_file
        echo "Remove those Docker Overlay2 Data!" >> $mail_text_file
        echo "" >> $mail_text_file
        echo "run: sudo service docker stop; sudo rm -f /var/lib/docker/overlay2/* ; sudo service docker start" >> $mail_text_file
        echo $mail_text_file
        sendmail $MAIL_ADDRESS < $mail_text_file
        # sendmail $MAIL_ADDRESS2 < $mail_text_file
    fi

    if [ $disk_usage -gt $THRESHOLD ]; then
        echo "Subject: /dev/sda2 Disk usage exceeds ${THRESHOLD}% - ACTION REQUIRED!" > $mail_text_file2
        echo "" >> $mail_text_file2
        echo "current Disk usage: ${disk_usage}%" >> $mail_text_file2
        echo "" >> $mail_text_file2
        echo "run: sudo service docker stop; sudo rm -f /var/lib/docker/overlay2* ; sudo service docker start" >> $mail_test_file2
        echo "" >> $mail_text_file2
        echo $mail_text_file2
        sendmail $MAIL_ADDRESS < $mail_text_file2
        # sendmail $MAIL_ADDRESS2 < $mail_text_file2
    fi

    if [ $scratch_usage -gt $THRESHOLD ]; then
        echo "Subject: scratch exceeds ${THRESHOLD}% - ACTION REQUIRED!" > $mail_text_file3
        echo "" >> $mail_text_file3
        echo "current scratch usage: ${scratch_usage}%" >> $mail_text_file3
        echo "" >> $mail_text_file3
        echo "Remove Netflow!" >> $mail_text_file3
        echo "" >> $mail_text_file3
        echo $mail_text_file3
        sendmail $MAIL_ADDRESS < $mail_text_file3
        # sendmail $MAIL_ADDRESS2 < $mail_text_file3
    fi

    # sleep 86400 # 1day
    # sleep 43200 # 1/2day
    # sleep 7200 # 2h
    sleep 3600 # 1h
done
