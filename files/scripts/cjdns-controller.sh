#!/bin/bash

# Copyright (c) 2018 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Encoding=UTF-8

stopcjdns(){
/etc/init.d/cjdns stop
sleep 2
systemctl stop cjdns
}

startcjdns(){
systemctl start cjdns
sleep 2
/etc/init.d/cjdns start
}

restartcjdns(){
/etc/init.d/cjdns restart
}

updatecjdns(){
mate-terminal -e 'bash -c "/etc/init.d/cjdns update"'
}

copyfile(){
systemctl stop cjdns
cp $ans /etc/cjdroute.conf
sleep 2
systemctl start cjdns
}

ipv4peers(){
/etc/init.d/cjdns stop
sleep 2
systemctl stop cjdns
sed -i "91i // Manually Added IPv4 Peers:" /etc/cjdroute.conf
sed -i "/ Manually Added IPv4 Peers:/r /$HOME/cjdns/cjdns_peers_ipv4" /etc/cjdroute.conf
chmod 600 /etc/cjdroute.conf
systemctl start cjdns
sleep 2
/etc/init.d/cjdns start
}

ipv6peers(){
/etc/init.d/cjdns stop
sleep 2
systemctl stop cjdns
sed -i "102i // Manually Added IPv6 Peers:" /etc/cjdroute.conf
sed -i "/ Manually Added IPv6 Peers:/r /$HOME/cjdns/cjdns_peers_ipv6" /etc/cjdroute.conf
chmod 600 /etc/cjdroute.conf
systemctl start cjdns
sleep 2
/etc/init.d/cjdns start
}

copyfile(){
if [ -f "/$HOME/cjdns/cjdroute.conf" ]
then
	cp /$HOME/cjdns/cjdroute.conf /etc/cjdroute.conf
	chmod 600 /etc/cjdroute.conf
else
	echo "$file not found."
fi
}

createconf(){
/opt/cjdns/cjdroute --genconf > /etc/cjdroute.conf
chmod 600 /etc/cjdroute.conf
}

status(){
mate-terminal -e 'bash -c "systemctl status cjdns -l; read line"'
}

peerstats(){
mate-terminal -e 'bash -c "/opt/cjdns/tools/peerStats; read line"'
}

getpeers(){
freshpeer=$(zenity  --list --title="GET NEW CJDNS PEERS" --height 230 --width 360 \
--text "Please select a region for your fresh peers.
Data will download to your home folder.
Manually copy and paste the data into the peers lists." --radiolist --column "Select" --column "Region" \
FALSE "North America" \
FALSE "Europe" \
FALSE "Asia");

	if [  "$freshpeer" = "North America" ]; then
		mate-terminal -e 'bash -c "curl https://peers.fc00.io/1/location/na >> peers.txt"'

	elif [  "$freshpeer" = "Europe" ]; then
		mate-terminal -e 'bash -c "curl https://peers.fc00.io/1/location/eu >> peers.txt"'

	elif [  "$freshpeer" = "Asia" ]; then
		mate-terminal -e 'bash -c "curl https://peers.fc00.io/1/location/as >> peers.txt"'

	fi
chmod 666 peers.txt
}

ans=$(zenity  --list --title="CJDNS/HYPERBORIA CONTROLLER" --height 510 --width 360 \
--text "Follow these steps to connect.
Relaunch this app for each step:
     1) Create the config file.
     2) Set Peers
     3) Restart Cjdns
     4) Check Peerstats
     5) Check Status" --radiolist --column "Select" --column "Task" \
FALSE "Create new config file (/etc/cjdroute.conf)" \
FALSE "Set IPv4 Peers (json formatted)" \
FALSE "Set IPv6 Peers  (json formatted)" \
FALSE "Restart CJDNS" \
FALSE "Check CJDNS peerstats" FALSE "Check CJDNS status" \
FALSE "Update CJDNS" FALSE "Use config file (~/cjdns/cjdroute.conf)" \
FALSE "Get Fresh Peers" FALSE "Start CJDNS" TRUE "Stop CJDNS" );

	if [  "$ans" = "Create new config file (/etc/cjdroute.conf)" ]; then
		createconf

	elif [  "$ans" = "Set IPv4 Peers (json formatted)" ]; then
		ipv4peers

	elif [  "$ans" = "Set IPv6 Peers  (json formatted)" ]; then
		ipv6peers

	elif [  "$ans" = "Restart CJDNS" ]; then
		restartcjdns

	elif [  "$ans" = "Check CJDNS peerstats" ]; then
		peerstats

	elif [  "$ans" = "Check CJDNS status" ]; then
		status

	elif [  "$ans" = "Update CJDNS" ]; then
		updatecjdns

	elif [  "$ans" = "Use config file (~/cjdns/cjdroute.conf)" ]; then
		copyfile

	elif [  "$ans" = "Get Fresh Peers" ]; then
		getpeers

	elif [  "$ans" = "Start CJDNS" ]; then
		startcjdns

	elif [  "$ans" = "Stop CJDNS" ]; then
		stopcjdns

	fi
