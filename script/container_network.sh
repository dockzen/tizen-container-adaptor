#!/bin/bash

set -e

HOSTS_FILE="/etc/hosts"
HOSTNAME_FILE="/etc/hostname"
SUBNETMASK="255.255.0.0"

if [ -s $HOSTNAME_FILE ] && [ -s $HOSTS_FILE ]; then
	HOSTNAME=`cat $HOSTNAME_FILE`

	while read line; do
		IP=$(echo $line | awk '{print $1}')
		HOST=$(echo $line | awk '{print $2}')
		if [ $HOSTNAME = $HOST ]; then
			CONTAINER_IP=$IP
#			echo $CONTAINER_IP
			break
		fi
	done < $HOSTS_FILE
fi

ORG_IP=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
if [ ! $ORG_IP ]; then
    ORG_IP="0.0.0.0"
fi
echo 'ip : '$ORG_IP

if [ $CONTAINER_IP != $ORG_IP ]; then
	var=$(echo $CONTAINER_IP | awk -F"." '{print $1,$2,$3,$4}')
	set -- $var 
	GATEWAY=$1'.'
	GATEWAY=$GATEWAY$2'.'
	GATEWAY=$GATEWAY$3'.'
	GATEWAY=$GATEWAY'1' 
	echo $GATEWAY
fi

if [ $CONTAINER_IP ] && [ $GATEWAY ]; then
	SERVICE=`connmanctl services | grep ethernet | awk '{print $3}'`
	connmanctl config $SERVICE --ipv4 manual $CONTAINER_IP $SUBNETMASK $GATEWAY
	echo 'staic IP setting by connman' $CONTAINER_IP
fi

exit
