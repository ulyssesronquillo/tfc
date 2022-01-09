#!/bin/bash

elb_json="elb.json"
web_json="web.json"
wow_json="wow.json"
swi_json="swi.json"

aws route53 change-resource-record-sets --hosted-zone-id Z16AGEC3IMI3R8 --change-batch file://$web_json --profile tfc
aws route53 change-resource-record-sets --hosted-zone-id Z16AGEC3IMI3R8 --change-batch file://$wow_json --profile tfc
aws route53 change-resource-record-sets --hosted-zone-id Z16AGEC3IMI3R8 --change-batch file://$swi_json --profile tfc
