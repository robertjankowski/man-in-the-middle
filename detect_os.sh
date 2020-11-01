#!/bin/bash

usage() {
  echo "Detect OS script"
  echo "Usage: ./detect_os.sh netdiscover_results.txt output_file.txt"
  echo "netdiscover_results.txt -- file where first columns has IP addresses"
  echo "output_file.txt -- to where save output from nmap command"
}

if [ "$#" -ne 2 ]; then
  usage
  exit
fi

netdiscover_results=$1
output_file=$2

# https://security.stackexchange.com/a/210683
cat $netdiscover_results | cut -d" " -f2 | while read ip; do echo ""; nmap -T4 -A $ip -v --append-output -oN $output_file; done
