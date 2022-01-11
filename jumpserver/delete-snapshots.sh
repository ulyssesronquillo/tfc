#!/bin/bash

profile='lightsail'
region=$2

# set variables
now=$(date)
current=$(date +%s)

# 7 day retention
dailyretention='604800'

# 4 week retention
weeklyretention='2419200'

# 6 month retention
monthlyretention='15552000'

# set filenames
snaps='/home/ubuntu/snapshots.json'
names='/home/ubuntu/names.txt'
parse='/home/ubuntu/parse.txt'
logfile='/home/ubuntu/home/snapshots.log'

# exit if no arguments
if [ $# -eq 0 ]; then
  exit 1
fi

# set expired dates
if [[ $1 = 'daily' ]]; then
  prefix='daily'
  expired=$(($current-$dailyretention))
elif [[ $1 = 'weekly' ]]; then
  prefix='weekly'
  expired=$(($current-$weeklyretention))
elif [[ $1 = 'monthly' ]]; then
  prefix='monthly'
  expired=$(($current-$monthlyretention))
else
  exit 1
fi

# get list of snapshots
aws lightsail get-instance-snapshots --region $region --profile $profile > $snaps
cat $snaps | jq -r '.instanceSnapshots[] | .name' > $names
cat $names | grep $prefix > $parse

echo '-----------------------------------' >> $logfile
echo $now >> $logfile

# read snapshots
while read -r line; do

  # get epoch time from name
  snapshot=$(echo $line | cut -d_ -f3)

  # set snapshotname
  snapshotname=$line

  # check if numeric
  if [ `expr $snapshot + 1 2> /dev/null` ] ; then

    # compare if snapshot is expired
    if [ $snapshot -le $expired ]; then

      # delete snapshot if expired. log it
      echo 'Deleted: '$snapshotname >> $logfile
      aws lightsail delete-instance-snapshot --instance-snapshot-name $snapshotname --region $region --profile $profile

    else

      # nothing to delete if not expired. log it
      echo 'Nothing: '$snapshotname >> $logfile

    fi

  # not numeric
  else
    echo $snapshot is not numeric > /dev/null
  fi

# we are done here
done < $parse

# log it
echo 'Current time: '$current >> $logfile
echo 'Expired time: '$expired >> $logfile

# clean up
rm $snaps
rm $names
rm $parse