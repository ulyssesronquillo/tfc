#!/bin/bash
echo '--------------------------------------------------------'
aws lightsail get-instance-snapshots --query 'instanceSnapshots[].[name]' --output text | sort
aws lightsail get-instance-snapshots --query 'instanceSnapshots[].[name]' --region eu-central-1 --output text | sort
echo '--------------------------------------------------------'
