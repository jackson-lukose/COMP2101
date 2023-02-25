#!/bin/bash

# Check if lxd is installed, if not then install it
if ! command -v lxd &> /dev/null
then
    sudo apt-get update
    sudo snap install lxd
fi

# Check if lxdbr0 interface exists, if not then initialize lxd
if ! ip link show lxdbr0 &> /dev/null
then
    sudo lxd init --auto
fi

# Launch container named COMP2101-S22 if it doesn't exist
if ! lxc list | grep -q COMP2101-S22
then
    lxc launch ubuntu:20.04 COMP2101-S22
fi

# Get container IP address
container_ip=$(lxc list | grep COMP2101-S22 | awk '{print $6}')

# Add or update entry in /etc/hosts for hostname COMP2101-S22 with container IP address
if ! grep -q "COMP2101-S22" /etc/hosts
then
    echo "$container_ip COMP2101-S22" | sudo tee -a /etc/hosts
else
    sudo sed -i "/COMP2101-S22/c\\$container_ip COMP2101-S22" /etc/hosts
fi

# Install Apache2 in container if not already installed
if ! lxc exec COMP2101-S22 -- command -v apache2 &> /dev/null
then
    lxc exec COMP2101-S22 -- apt-get update
    lxc exec COMP2101-S22 -- apt-get install -y apache2
fi

# Install curl if not already installed
if ! command -v curl &> /dev/null
then
    sudo apt-get update
    sudo apt-get install -y curl
fi

# Retrieve default web page from container's web service and notify user of success or failure
response=$(curl -s -o /dev/null -w "%{http_code}" http://COMP2101-S22)
if [[ $response -eq 200 ]]
then
    echo "Web server is running successfully!"
else
    echo "Error: Could not connect to web server."
fi
