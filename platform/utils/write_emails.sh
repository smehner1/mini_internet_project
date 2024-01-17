#!/bin/bash

USEVPN=0

if [ $# -ne 1 ]; then
    echo $0: usage /write_emails.sh group_number
    exit 1
fi

group_number=$1

echo "Hi Group $group_number,"
echo ''
echo 'To access our server where the mini-Internet is running, use the following command:'
echo "ssh -p $((2000+$group_number)) root@mittelerde.informatik.tu-cottbus.de"
echo ''
echo 'Note that mittelerde is only accessible _within_ BTUs network. E.g., by using'
echo 'mouse.informatik.tu-cottbus.de as stepping stone to the internal network'
echo '(access with your BTU account credentials) or by using the BTU VPN service.'

passwd=`awk -vgroup="$group_number" '$1 == group { print $2 }' ./groups/ssh_passwords.txt`

echo ''
echo "Your password is: $passwd"


echo ''
echo 'The password to access the measurement container is '$(cat ./groups/ssh_measurement.txt)

if [ $USEVPN -eq 1 ]; then
	port1=$(cat groups/g$group_number/vpn/vpn_1/server.conf | grep port | cut -f 2 -d ' ')
	port2=$(cat groups/g$group_number/vpn/vpn_3/server.conf | grep port | cut -f 2 -d ' ')

	echo ''
	echo "Below, you can find the content of the ca.crt files you need to access your VPN servers (required for the bonus question)."

	echo "To access the VPN server connected to CERN, copy the following text into the ca.crt file and use the port $port1."
	echo ''
	cat groups/g$group_number/vpn/vpn_1/ca.crt

	echo ''

	echo "To access the VPN server connected to EPFL, copy the following text into the ca.crt file and use the port $port2."
	echo ''
	cat groups/g$group_number/vpn/vpn_3/ca.crt
fi

echo ''
echo 'Good luck with the project, and let us know if you have any question.'
echo 'The Internet team'

