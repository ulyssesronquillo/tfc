#!/bin/bash

# Load config file ....
wowza_json="/home/ubuntu/wowza.json"
startLog="/home/ubuntu/start.log"

# load AMIs
#source /root/scripts/config.sh
wowza_ami='ami-0721a6f846f7a3dfe'
#wowza_ami='ami-02d1c80b8c9362f77'
switcher_ami='ami-0b6470adf2c017ba4'
switcher_ami='ami-0c93d8544a2d04de4'

elb () {
  /home/ubuntu/autoscaler.sh 3
  /home/ubuntu/elb.sh
}

switcher () {
  dateNow=$(date)
  echo 'Starting Cloud Switcher '$switcher_ami' on '$dateNow >> $startLog
  aws ec2 run-instances \
  --count 1 \
  --region us-east-2 \
  --key-name tfc-ohio \
  --image-id $switcher_ami \
  --instance-type c5.2xlarge \
  --subnet-id subnet-18b23a70 \
  --iam-instance-profile Name=machinerole \
  --security-group-ids sg-074ebb86f85c80f97 \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Cloud-Switcher}]' 'ResourceType=volume,Tags=[{Key=Name,Value=Cloud-Switcher}]'
  # Pause to allow instance to boot up ....
  sleep 45s
  echo 'Associating Elastic IP Address 18.221.164.61 to Cloud Switcher on '$dateNow >> $startLog
  # Associate Elastic IP Address ....
  aws ec2 describe-instances --region us-east-2 --filters Name=tag:Name,Values=Cloud-Switcher Name=instance-state-name,Values=running > $wowza_json
  INSTANCEID=$(cat $wowza_json | jq '.Reservations[].Instances[] | {InstanceId} | .InstanceId' --raw-output)
  aws ec2 associate-address --region us-east-2 --instance-id $INSTANCEID --public-ip 18.221.164.61
}

wowza () {
  dateNow=$(date)
  echo 'Starting Wowza Server '$wowza_ami' on '$dateNow >> $startLog
  aws ec2 run-instances \
  --count 1 \
  --region us-east-2 \
  --key-name tfc-ohio \
  --image-id $wowza_ami \
  --instance-type c5.2xlarge \
  --subnet-id subnet-18b23a70 \
  --private-ip-address 10.0.4.100 \
  --iam-instance-profile Name=machinerole \
  --security-group-ids sg-0a03a540831cc1a0c \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Wowza-Streaming-Engine}]' 'ResourceType=volume,Tags=[{Key=Name,Value=Wowza-Streaming-Engine}]'
  # Pause to allow instance to boot up ....
  sleep 45s
  echo 'Associating Elastic IP Address 18.219.145.3 to Wowza Server on '$dateNow >> $startLog
  # Associate Elastic IP Address ....
  aws ec2 describe-instances \
  --region us-east-2 \
  --filters Name=tag:Name,Values=Wowza-Streaming-Engine Name=instance-state-name,Values=running > $wowza_json
  INSTANCEID=$(cat $wowza_json | jq '.Reservations[].Instances[] | {InstanceId} | .InstanceId' --raw-output)
  aws ec2 associate-address --region us-east-2 --instance-id $INSTANCEID --public-ip 18.219.145.3
}

icecast () {
  aws ec2 run-instances \
  --region us-east-2 \
  --image-id ami-c53102a0 \
  --count 1 \
  --instance-type t2.small \
  --key-name tfc-ohio \
  --security-group-ids sg-4cb3fc27 \
  --subnet-id subnet-18b23a70 \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Icecast}]' 'ResourceType=volume,Tags=[{Key=Name,Value=Icecast}]'
  sleep 15s
  aws ec2 describe-instances \
  --region us-east-2 \
  --filters Name=tag:Name,Values=Icecast Name=instance-state-name,Values=running > /var/www/wowza.json
  INSTANCEID=$(cat /var/www/wowza.json | jq '.Reservations[].Instances[] | {InstanceId} | .InstanceId' --raw-output)
  aws ec2 associate-address --region us-east-2 --instance-id $INSTANCEID --public-ip 52.15.107.245
}

cleanup () {
  sleep 10s
  rm -f $wowza_json
}

elb
switcher
wowza
cleanup
