#!/bin/bash

usage() {
  echo "Port scanning script"
  echo "Usage: ./find_open_ports.sh SOME_IP_ADDR 0"
  echo "SOME_IP_ADDR -- ip of victim"
  echo "0 - run without proxychains, 1 - run with proxychains"
}

if [ "$#" -ne 2 ]; then
  usage
  exit
fi

ip=$1
proxychains=$2

ports_command="nmap -p- --min-rate=1000 -T4 $ip | grep ^[0-9] | cut -d '/' -f
1 | tr '\n' ',' | sed s/,$//"

if [ $proxychains == 1 ]; then
  ports_command="proxychains "$ports_command
fi

ports=$(eval $ports_command)

if [ "$ports" == "" ]; then
  echo "No open ports available on $ip"
  exit
fi

echo "Scanning ports..."$ports
nmap -sC -sV -p$ports $ip
