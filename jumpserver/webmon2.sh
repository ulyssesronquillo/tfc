#!/bin/bash

#setting variables
now=$(date)
domain="http://$1"
log="logs/webmon.log"

#checking if no arguments
if [[ $1 = "" ]]; then
  echo "Format: webmon.sh https://domain.com"
  exit
fi

#checking website
if curl -s --head  --request GET $domain | grep "302 Found" > /dev/null; then 
  echo "$now $domain is UP." >> $log
else
  echo "$now $domain is DOWN. Rebooting $domain." >> $log
  aws lightsail reboot-instance --instance-name thefatherscall.org2 --profile lightsail --region us-east-2 >> $log
fi
