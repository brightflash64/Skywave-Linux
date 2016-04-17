#!/bin/sh
Encoding=UTF-8

stopcjdns(){
/etc/init.d/hyperboria stop
sleep 2
systemctl stop cjdns
}

startcjdns(){
systemctl start cjdns
sleep 2
/etc/init.d/hyperboria start
}

restartcjdns(){
/etc/init.d/hyperboria restart
}

updatecjdns(){
/etc/init.d/hyperboria update
}

copyfile(){
systemctl stop cjdns
cp $ans /etc/cjdroute.conf
sleep 2
systemctl start cjdns
}

ipv4peers(){
/etc/init.d/hyperboria stop
sleep 2
systemctl stop cjdns
sed -i "91i // Manually Added IPv4 Peers:" /etc/cjdroute.conf
sed -i '/ Manually Added IPv4 Peers:/r /usr/local/sbin/cjdns/cjdns_peers_ipv4' /etc/cjdroute.conf
chmod 600 /etc/cjdroute.conf
systemctl start cjdns
sleep 2
/etc/init.d/hyperboria start
}

ipv6peers(){
/etc/init.d/hyperboria stop
sleep 2
systemctl stop cjdns
sed -i "102i // Manually Added IPv6 Peers:" /etc/cjdroute.conf
sed -i '/ Manually Added IPv6 Peers:/r /usr/local/sbin/cjdns/cjdns_peers_ipv6' /etc/cjdroute.conf
chmod 600 /etc/cjdroute.conf
systemctl start cjdns
sleep 2
/etc/init.d/hyperboria start
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
cjdroute --genconf > /etc/cjdroute.conf
chmod 600 /etc/cjdroute.conf
}

ans=$(zenity  --list --title="CJDNS/HYPERBORIA CONTROLLER" --height 290 --width 350 \
--text "Please pick from this list." --radiolist --column "Pick" \
TRUE "Stop CJDNS" FALSE "Start CJDNS" FALSE "Restart CJDNS"  FALSE "Update CJDNS" \
FALSE "Set IPv4 Peers (json formatted)" FALSE "Set IPv6 Peers  (json formatted)" \
FALSE "Use config file (~/cjdns/cjdroute.conf)" FALSE "Create new config file (/etc/cjdroute.conf)" \
--column "Action");

	if [  "$ans" = "Stop CJDNS" ]; then
		stopcjdns

	elif [  "$ans" = "Start CJDNS" ]; then
		startcjdns

	elif [  "$ans" = "Restart CJDNS" ]; then
		restartcjdns

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
