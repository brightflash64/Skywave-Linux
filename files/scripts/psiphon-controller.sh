#!/bin/bash

# Copyright (c) 2018 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

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
python ./psi_client.py
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
