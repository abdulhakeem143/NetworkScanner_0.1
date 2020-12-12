#!/bin/bash
#Indentify all hosts on your subnet within a given range and update the arp cache

network_id=$(ip -4 addr show eth0 | grep inet | awk -F" " {' print $2 '} | awk -F"." {' print $1"."$2"."$3 '})

echo -n "Starting IP: $network_id."
read startip
echo -n "Ending IP: $network_id."
read endip

echo "Searching for hosts on $network_id.$startip-$endip..."

for(( i=startip; i<endip; i++)); do
	ping -c 1 -w 1 "$network_id.$i"
done

echo "Search compleate..."
sudo arp -e | grep -v incomplete > /home/kali/Documents/arp_cache_$(date +%F) 

echo "Current arp cache:"
sudo arp -e

echo -n "Would you like to remove incomplete entries from arp cache (y/n): "
read choice
if [ "$choice" = y ]; then
	clear
	echo "Updated arp chache:"
	grep -v address /home/kali/Documents/arp_cache_$(date +%F) | awk -F" " {' print $1" "$3 '} > /home/kali/Documents/update
	sudo ip -s neigh flush all
	sudo arp -f /home/kali/Documents/update
	sudo rm /home/kali/Documents/update
	sudo arp -e
fi
