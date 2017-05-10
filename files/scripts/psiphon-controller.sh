#!/bin/sh
Encoding=UTF-8

psiphonstart(){
cd /usr/local/sbin/psiphon/
python ./psi_client.py -u
python ./psi_client.py -a
psiphonstop
}

psiphonstop(){
sudo pkill -f "python ./psi_client.py"
exit
}

ans=$(zenity  --list  --title "PSIPHON CONTROLLER" --text "Start and stop Psiphon" --radiolist  --column "Pick" --column "Action" TRUE "Start Psiphon" FALSE "Stop Psiphon");

	if [  "$ans" = "Start Psiphon" ]; then
		psiphonstart
	else 
		psiphonstop
	fi
