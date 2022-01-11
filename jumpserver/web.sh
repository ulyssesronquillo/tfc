#!/bin/bash
web_json="/home/ubuntu/web.json"
aws route53 change-resource-record-sets --hosted-zone-id Z16AGEC3IMI3R8 --change-batch file://$web_json
