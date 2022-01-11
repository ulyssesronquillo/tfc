#!/bin/bash

echo 'Choose a server to reboot ...'
echo '1) thefatherscall.org'
echo '2) thefatherscall.org2'
echo '3) thefatherscall.de'
echo '4) leadingtolife.org'
echo '5) truthsum.org'
echo 'q) Quit'
read -p 'Choose a server to reboot: ' server

case $server in 
	1)
		echo 'Rebooting thefatherscall.org ...'
		aws lightsail reboot-instance --instance-name thefatherscall.org --profile lightsail --region us-east-2
		echo 'Done'
		;;
	2)
	        echo 'Rebooting thefatherscall.org2 ...'
		aws lightsail reboot-instance --instance-name thefatherscall.org2 --profile lightsail --region us-east-2
		echo 'Done'
		;;
	3)
		echo 'Rebooting thefatherscall.de ...'
		aws lightsail reboot-instance --instance-name thefatherscall.de --profile lightsail --region us-east-2
		echo 'Done'
		;;
	4)
		echo 'Rebooting leadingtolife.org ...'
		aws lightsail reboot-instance --instance-name leadingtolife.org --profile lightsail --region us-east-2
		echo 'Done'
		;;
	5)
		echo 'Rebooting truthsum.org ...'
		aws lightsail reboot-instance --instance-name truthsum.org --profile lightsail --region us-east-2
		echo 'Done'
		;;
	q)
		echo 'Quit'
		;;
	*)
		echo 'Invalid option' $server
		;;
esac
