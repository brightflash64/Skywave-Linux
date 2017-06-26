#!/bin/sh
Encoding=UTF-8

psiphonstop(){
sudo pkill -f "python ./psi_client.py"
exit
}

updatestart(){
cd /usr/local/sbin/psiphon/
python ./psi_client.py -u
psiphonstart
psiphonstop
}

psiphonstart(){
cd /usr/local/sbin/psiphon/
python ./psi_client.py -a
psiphonstop
}

ans=$(zenity  --list  --title "PSIPHON CONTROLLER" --text "Start and stop Psiphon" --radiolist  --column "Pick" --column "Action" TRUE "Start Psiphon" FALSE "Update and Start Psiphon" FALSE "Stop Psiphon");

	if [  "$ans" = "Start Psiphon" ]; then
		psiphonstart

	elif [  "$ans" = "Update and Start Psiphon" ]; then
		updatestart

	elif [  "$ans" = "Stop Psiphon" ]; then 
		psiphonstop

	fi
