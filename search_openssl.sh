#!/bin/bash

hostname=google.com

ciphers_raw=$(openssl ciphers)
ciphers=($(echo $ciphers_raw | tr ':' "\n"))

echo ${ciphers[@]}

for c in ${ciphers[@]}; do
	
	echo Testing Cipher: $c
	openssl_output=$(echo | openssl s_client -connect $hostname:443 -cipher $c 2>&1)

	if [[ "$(echo $openssl_output | grep -iwo failed)" == "failed" ]];then
		echo CIPHER $c NOT COMPATIBLE WITH $hostname

		echo $c,0 >> ${hostname}_comp.csv
	else
		echo OK
		echo $c,1 >> ${hostname}_comp.csv
	fi
done
