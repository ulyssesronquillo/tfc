#!/bin/bash
aws route53 list-resource-record-sets --hosted-zone-id Z16AGEC3IMI3R8 --query "ResourceRecordSets[?Name=='wowza.thefatherscall.org.']"
aws route53 list-resource-record-sets --hosted-zone-id Z16AGEC3IMI3R8 --query "ResourceRecordSets[?Name=='switcher.thefatherscall.org.']"
aws route53 list-resource-record-sets --hosted-zone-id Z16AGEC3IMI3R8 --query "ResourceRecordSets[?Name=='live.thefatherscall.org.']"
