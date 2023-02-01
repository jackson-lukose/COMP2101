#!/bin/bash

#Get the fully-qualified domain name (FQDN)
fqdn=$(hostname --fqdn)

#Get the operating system name and version
os=$(hostnamectl)

#Get the IP addresses that are not on the 127 network
ipadd=$(hostname -I | grep -v "127.")

#Get the amount of space available in only the root filesystem in human friendly
rootfiles=$(df -h /)

#Display the information

cat << EOF

FQDN: $fqdn

Host Information:
$os

IP Addresses: $ipadd

Root Filessystem Available:
$rootfiles
EOF
