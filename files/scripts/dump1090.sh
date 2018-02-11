#!/bin/bash

# Copyright (c) 2018 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

start0() {
cp /usr/local/sbin/dump1090/public_html/config.js.orig /usr/local/sbin/dump1090/public_html/config.js
# edit the config file with actual lat/lon
sed -i "
     14s/.*/CONST_CENTERLAT = $latitude;/ ;
     15s/.*/CONST_CENTERLON = $longitude;/ ;
     28s/.*/SiteLat = $latitude;/ ;
     29s/.*/SiteLon = $longitude;/" /usr/local/sbin/dump1090/public_html/config.js

# run dump1090
cd /usr/local/sbin/dump1090/
./dump1090 --gain $gain --net --interactive --phase-enhance --net-sbs-port 30003 --lat $latitude --lon $longitude --ppm $ppm &
sleep 2
python dump1090-stream-parser.py -d ~/adsbserv.db &
sleep 2
firefox --new-tab http://127.0.0.1:8080
stop
}

start1() {
cp /usr/local/sbin/dump1090/public_html/config.js.orig /usr/local/sbin/dump1090/public_html/config.js
# edit the config file with actual lat/lon
sed -i "
     14s/.*/CONST_CENTERLAT = $latitude;/ ;
     15s/.*/CONST_CENTERLON = $longitude;/ ;
     28s/.*/SiteLat = $latitude;/ ;
     29s/.*/SiteLon = $longitude;/" /usr/local/sbin/dump1090/public_html/config.js

# run dump1090
cd /usr/local/sbin/dump1090/
rx_sdr -f 1090000000 -p $ppm -g $gain - | ./dump1090 --net --interactive --phase-enhance --net-sbs-port 30003 --lat $latitude --lon $longitude --ppm $ppm --ifile - &
sleep 2
python dump1090-stream-parser.py -d ~/adsbserv.db &
sleep 2
firefox --new-tab http://127.0.0.1:8080
stop
}

stop(){
killall -9 dump1090
pkill -f "python ./dump1090-stream-parser.py"
}

OUTPUT=$(zenity --forms --title="Dump1090" --text="Enter the Dump1090 start-up parameters. \nFor example, in New York and a 30 ppm correction you enter 40.7, -74.0, and 30" \
--separator="," --add-entry="Latitude (degrees.decimals)" --add-entry="Longitude (degrees.decimals)" \
--add-entry="Gain Setting" --add-entry="Freq Correction (ppm)");

if [[ "$?" -ne "0" || -z "$?" ]]; then
    echo "something went wrong"
    stop
fi

latitude=$(awk -F, '{print $1}' <<<$OUTPUT)
longitude=$(awk -F, '{print $2}' <<<$OUTPUT)
gain=$(awk -F, '{print $3}' <<<$OUTPUT)
ppm=$(awk -F, '{print $4}' <<<$OUTPUT)


type=$(zenity  --list --title="INDICATE DEVICE" --height 200 --width 350 \
--text "Please indicate the device to be used." --radiolist --column "Select" --column "Region" \
TRUE "RTL-SDR (use dump1090-mutability)" \
FALSE "SoapySDR Compatible (use rx_tools)");


	if [ "$type" = "RTL-SDR (use dump1090-mutability)" ]; then
    		start0

	elif [ "$type" = "SoapySDR Compatible (use rx_tools)" ]; then
		hardware=""
    		start1

	fi

