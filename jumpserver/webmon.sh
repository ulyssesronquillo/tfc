#!/bin/bash

#setting variables
now=$(date)
domain="https://$1"
log="logs/webmon.log"

#checking if no arguments
if [[ $1 = "" ]]; then
  echo "Format: webmon.sh https://domain.com"
  exit
fi

#checking website
if curl -s --head --request GET $domain | grep "200 OK" > /dev/null; then 
  echo "$now $domain is UP." >> $log
else
  aws lightsail reboot-instance --instance-name $1 --profile lightsail --region us-east-2 >> $log
fi
