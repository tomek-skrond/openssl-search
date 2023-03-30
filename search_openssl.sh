#!/bin/bash

hostname=$1

if [ $# -eq 0 ];then
	echo "No arguments passed, defaulting to hostname=google.com"
	hostname=google.com
fi

#getting raw output of all openssl supported ciphers
ciphers_raw=$(openssl ciphers)
#converting ciphers into an array of cipher names
ciphers=($(echo $ciphers_raw | tr ':' "\n"))

#displaying all ciphers
echo ${ciphers[@]}

#iterating through all ciphers
for c in ${ciphers[@]}; do
	
	echo Testing Cipher: $c
	openssl_output=$(echo | openssl s_client -connect $hostname:443 -cipher $c 2>&1)

	if [[ "$(echo $openssl_output | grep -iwo failed)" == "failed" ]];then
		echo CIPHER $c NOT COMPATIBLE WITH $hostname

		#if cipher not compatible for connection -> save to csv with '0'
		echo $c,0 >> ${hostname}_comp.csv
	else
		#if cipher compatible -> save to csv with '1'
		echo OK
		echo $c,1 >> ${hostname}_comp.csv
	fi
done
