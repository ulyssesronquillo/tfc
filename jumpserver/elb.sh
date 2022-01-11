#!/bin/bash

elb_json="/home/ubuntu/elb.json"
wow_json="/home/ubuntu/wow.json"
swi_json="/home/ubuntu/swi.json"

aws route53 change-resource-record-sets --hosted-zone-id Z16AGEC3IMI3R8 --change-batch file://$elb_json
aws route53 change-resource-record-sets --hosted-zone-id Z16AGEC3IMI3R8 --change-batch file://$wow_json
aws route53 change-resource-record-sets --hosted-zone-id Z16AGEC3IMI3R8 --change-batch file://$swi_json
