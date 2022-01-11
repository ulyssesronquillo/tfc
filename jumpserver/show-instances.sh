#!/bin/bash
aws ec2 describe-instances --query 'Reservations[*].Instances[?!contains(State.Name,`terminated`)].{Name:Tags[?Key==`Name`]|[0].Value}' --output text
