#!/bin/bash

#Get the fully-qualified domain name (FQDN)
fqdn=$(hostname --fqdn)

#Get the operating system name and version
os=$(hostnamectl | grep "Operating System" | awk '{print $3,$4}')

#Get the IP addresses that are not on the 127 network
ipadd=$(ip route | grep default | awk '{print $3}')

#Get the amount of space available in only the root filesystem in human friendly
rootfiles=$(df -h /| awk '/\/$/ {print $4}')

#Display the information

cat << EOF  

Report for myvm

===============

FQDN: $fqdn
Operating System Name and Version: $os
IP Address: $ipadd
Root Filessystem Free Space: $rootfiles

================
EOF
