#!/bin/bash

# Copyright (c) 2019 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# Capture, decode, and save ADS-B data.

startlog() {
OUTPUT=$(zenity --forms --title="Dump1090 (SoapySDR)" \
--text="Enter the Dump1090 start-up parameters. Specify the device driver and key \nreported by \"SoapySDRUtil --find.\"" \
--separator="," \
--add-entry="SoapySDR Device Driver (e.g. rtlsdr):" \
--add-entry="SoapySDR Device Key (e.g. rtl=0):" \
--add-entry="Gain Setting" \
--add-entry="Freq Correction (ppm)");

if [[ "$?" -ne "0" || -z "$?" ]]; then
    stop
    exit
fi

driver=$(awk -F, '{print $1}' <<<$OUTPUT)
devkey=$(awk -F, '{print $2}' <<<$OUTPUT)
gain=$(awk -F, '{print $3}' <<<$OUTPUT)
ppm=$(awk -F, '{print $4}' <<<$OUTPUT)
comma=","

# run dump1090
rx_sdr -f 1090000000 -s 2000000 -p $ppm -g $gain -d driver=$driver$comma$devkey -N 1 - | dump1090 --net --interactive --net-sbs-port=30003 &
nc -l 127.0.0.1 -p 30003 | egrep --line-buffered 'MSG,1|MSG,3|MSG,4|MSG,6' >> ~/adsb.log
}

startplot() {
OUTPUT=$(zenity --forms --title="Dump1090 (SoapySDR)" \
--text="Enter the Dump1090 start-up parameters. For example, \nin New York and a 30 ppm correction you enter 40.7,\n-74.0, and 30.  Specify the device driver and key \nreported by \"SoapySDRUtil --find.\"" \
--separator="," \
--add-entry="Latitude (degrees.decimals)" \
--add-entry="Longitude (degrees.decimals)" \
--add-entry="SoapySDR Device Driver (e.g. rtlsdr):" \
--add-entry="SoapySDR Device Key (e.g. rtl=0):" \
--add-entry="Gain Setting" \
--add-entry="Freq Correction (ppm)");

if [[ "$?" -ne "0" || -z "$?" ]]; then
    stop
    exit
fi

latitude=$(awk -F, '{print $1}' <<<$OUTPUT)
longitude=$(awk -F, '{print $2}' <<<$OUTPUT)
driver=$(awk -F, '{print $3}' <<<$OUTPUT)
devkey=$(awk -F, '{print $4}' <<<$OUTPUT)
gain=$(awk -F, '{print $5}' <<<$OUTPUT)
ppm=$(awk -F, '{print $6}' <<<$OUTPUT)
comma=","

cp /usr/local/sbin/dump1090/public_html/config.js.orig /usr/local/sbin/dump1090/public_html/config.js
# edit the config file with actual lat/lon
sed -i "
     27s/.*/DefaultCenterLat = $latitude;/ ;
     28s/.*/DefaultCenterLon = $longitude;/ ;
     36s/.*/SiteLat = $latitude;/ ;
     37s/.*/SiteLon = $longitude;/" /usr/local/sbin/dump1090/public_html/config.js

# run dump1090
rx_sdr -f 1090000000 -s 2000000 -p $ppm -g $gain -d driver=$driver$comma$devkey -N 1 - | dump1090 --net --interactive --net-sbs-port=30003 --lat=$latitude --lon=$longitude --ifile=- &
# Stop here...fix this to use pythom mapping scripts.
WINDOW=$(zenity --info --height 100 --width 350 \
--title="Dump1090 - Reserved." \
--text="This selection is reserved for future use");
}

stop(){
killall -9 dump1090 rx_sdr nc
pkill -f dump1090-stream-parser
exit
}

ans=$(zenity  --list  --title "Dump1090" --height=200 --width=400 \
--text "Manage ADS-B logging and plotting" \
--radiolist  --column "Pick" --column "Action" \
FALSE "Start Dump1090 and write to a logfile." \
FALSE "Start Dump1090 and plot aircraft positions." \
TRUE "Stop Dump1090");

	if [  "$ans" = "Start Dump1090 and write to a logfile." ]; then
		startlog

	elif [  "$ans" = "Start Dump1090 and plot aircraft positions." ]; then
		startplot

	elif [  "$ans" = "Stop Dump1090" ]; then
		stop

	fi

