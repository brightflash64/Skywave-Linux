#!/bin/sh
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
/etc/init.d/cjdns update
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
gnome-terminal -e 'bash -c "systemctl status cjdns -l; read line"'
}

peerstats(){
gnome-terminal -e 'bash -c "/opt/cjdns/tools/peerStats; read line"'
}

ans=$(zenity  --list --title="CJDNS/HYPERBORIA CONTROLLER" --height 330 --width 350 \
--text "Please pick from this list." --radiolist --column "Pick" \
TRUE "Stop CJDNS" FALSE "Start CJDNS" FALSE "Restart CJDNS"  FALSE "Check CJDNS status" \
FALSE "Check CJDNS peerstats" FALSE "Update CJDNS" \
FALSE "Set IPv4 Peers (json formatted)" FALSE "Set IPv6 Peers  (json formatted)" \
FALSE "Use config file (~/cjdns/cjdroute.conf)" FALSE "Create new config file (/etc/cjdroute.conf)" \
--column "Action");

	if [  "$ans" = "Stop CJDNS" ]; then
		stopcjdns

	elif [  "$ans" = "Start CJDNS" ]; then
		startcjdns

	elif [  "$ans" = "Restart CJDNS" ]; then
		restartcjdns

	elif [  "$ans" = "Check CJDNS status" ]; then
		status

	elif [  "$ans" = "Check CJDNS peerstats" ]; then
		peerstats

	elif [  "$ans" = "Update CJDNS" ]; then
		updatecjdns

	elif [  "$ans" = "Set IPv4 Peers (json formatted)" ]; then
		ipv4peers

	elif [  "$ans" = "Set IPv6 Peers  (json formatted)" ]; then
		ipv6peers

	elif [  "$ans" = "Use config file (~/cjdns/cjdroute.conf)" ]; then
		copyfile

	elif [  "$ans" = "Create new config file (/etc/cjdroute.conf)" ]; then
		createconf

	fi
