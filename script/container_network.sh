#!/bin/bash

set -e

HOSTS_FILE="/etc/hosts"
HOSTNAME_FILE="/etc/hostname"
SUBNETMASK="255.255.255.0"

if [ -s $HOSTNAME_FILE ] && [ -s $HOSTS_FILE ]; then
	HOSTNAME=`cat $HOSTNAME_FILE`	
	HOST=$(cat $HOSTS_FILE | grep $HOSTNAME | cut -f2)
	IP=$(cat $HOSTS_FILE | grep $HOSTNAME | cut -f1)
	CONTAINER_IP=$IP
	echo 'host :' $HOSTNAME
	echo 'host2 :' $HOST
	echo 'IP :' $IP	

fi


FIRST=$(echo $CONTAINER_IP | cut -d . -f1)
SECOND=$(echo $CONTAINER_IP | cut -d . -f2)
THIRD=$(echo $CONTAINER_IP | cut -d . -f3)
FORTH=$(echo $CONTAINER_IP | cut -d . -f4)

GATEWAY=$FIRST'.'
GATEWAY=$GATEWAY$SECOND'.'
GATEWAY=$GATEWAY$THIRD'.'
GATEWAY=$GATEWAY'1' 
echo $GATEWAY


if [ $CONTAINER_IP ] && [ $GATEWAY ]; then
	SERVICE=`connmanctl services | grep ethernet | rev | cut -d ' ' -f1 | rev`
	connmanctl config $SERVICE --ipv4 manual $CONTAINER_IP $SUBNETMASK $GATEWAY
	echo 'staic IP setting by connman' $CONTAINER_IP
fi

exit
