#!/bin/sh

# Copyright (c) 2019 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# Capture, decode, and save AIS data.

dumptofile() {
rtl_ais -p 43 -g 30
nc 127.0.0.1 10110 > ~/ais_log.txt &
WINDOW=$(zenity --info --height 100 --width 350 \
--title="RTL-AIS - Running." \
--text="The dual channel AIS monitor is running.
To stop, use this application and select \"Stop AIS capture and logging.\""
);
}

stopcapture() {
killall rtl_ais nc
}

startmapper() {
WINDOW=$(zenity --info --height 100 --width 350 \
--title="RTL-AIS - Reserved." \
--text="This selection is reserved for future use"
);
}

ans=$(zenity  --list  --title "AIS MONITOR" --width=500 --height=200 \
--text "Manage capture and plotting of AIS data." \
--radiolist  --column "Pick" --column "Action" \
FALSE "Capture AIS signals and write to a logfile."  \
FALSE "Plot AIS data on a map." \
TRUE "Stop AIS capture and logging.");

	if [  "$ans" = "Capture AIS signals and write to a logfile." ]; then
		dumptofile

	elif [  "$ans" = "Plot AIS data on a map." ]; then
		startmapper

	elif [  "$ans" = "Stop AIS capture and logging." ]; then
		stopcapture

	fi
