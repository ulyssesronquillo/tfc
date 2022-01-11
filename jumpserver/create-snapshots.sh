#!/bin/bash

# 
# format: create-snapshot.sh name daily
#

profile='lightsail'

name=$1
prefix=$2
region=$3

if [ $# -eq 3 ]; then
  timestamp=$(date +%s)
  snapshotname=$prefix'_'$name'_'$timestamp
  aws lightsail create-instance-snapshot \
  --instance-snapshot-name $snapshotname \
  --instance-name $name \
  --region $region \
  --profile $profile
else
  echo 'Need two arguments. create.sh name weekly'
fi