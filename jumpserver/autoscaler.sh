#!/bin/bash

# Format:  
# ./auto-scaling.sh 3
# ./auto-scaling.sh 0

int=$1

aws autoscaling update-auto-scaling-group \
--auto-scaling-group-name livestream-web-asg \
--min-size $int \
--max-size $int \
--desired-capacity $int \
--region us-east-2