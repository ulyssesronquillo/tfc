#!/bin/bash

stopLog="/home/ubuntu/stop.log"
wowza_json="/home/ubuntu/wowza.json"

web () {
  sh /home/ubuntu/autoscaler.sh 0
  sh /home/ubuntu/web.sh
}

switcher () {
  dateNow=$(date)
  echo 'Terminating Cloud Switcher on '$dateNow >> $stopLog
  aws ec2 describe-instances \
  --region us-east-2 \
  --filters Name=tag:Name,Values=Cloud-Switcher Name=instance-state-name,Values=running > $wowza_json
  INSTANCEID=$(cat $wowza_json | jq '.Reservations[].Instances[] | {InstanceId} | .InstanceId' --raw-output)
  aws ec2 terminate-instances --region us-east-2 --instance-ids $INSTANCEID
}

wowza () {
  dateNow=$(date)
  echo 'Terminating Wowza Server on '$dateNow >> $stopLog
  aws ec2 describe-instances \
  --region us-east-2 \
  --filters Name=tag:Name,Values=Wowza-Streaming-Engine Name=instance-state-name,Values=running > $wowza_json
  INSTANCEID=$(cat $wowza_json | jq '.Reservations[].Instances[] | {InstanceId} | .InstanceId' --raw-output)
  aws ec2 terminate-instances --region us-east-2 --instance-ids $INSTANCEID
}

icecast () {
  aws ec2 describe-instances \
  --region us-east-2 \
  --filters Name=tag:Name,Values=Icecast Name=instance-state-name,Values=running > /var/www/wowza.json
  INSTANCEID=$(cat wowza.json | jq '.Reservations[].Instances[] | {InstanceId} | .InstanceId' --raw-output)
  aws ec2 terminate-instances --region us-east-2 --instance-ids $INSTANCEID
}

cleanup () {
  sleep 10s
  rm -f $wowza_json
}

web
switcher
wowza
cleanup
