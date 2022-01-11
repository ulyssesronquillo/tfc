#!/bin/bash

hook_message="hook_message.txt"
hook_file="hook_file.txt"
> $hook_message

aws ec2 describe-instances --query 'Reservations[*].Instances[?!contains(State.Name,`terminated`)].{Name:Tags[?Key==`Name`]|[0].Value}' --output text > $hook_file

echo "The following servers were started: " >> $hook_message

while read line; do    
    echo $line >> $hook_message   
done < $hook_file

message=$(cat hook_message.txt)
