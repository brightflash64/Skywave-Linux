#!/bin/bash

# Copyright (c) 2018 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

start0(){
#start the icecast server
service icecast2 start
sleep 3
#start rtlsdr-airband
sudo /usr/local/bin/rtl_airband
sleep 3
firefox --new-tab http://127.0.0.1:8000
stop
}

start1(){
#build the config file
buildconf
#start the icecast server
service icecast2 start
sleep 3
#start rtlsdr-airband
sudo /usr/local/bin/rtl_airband
sleep 3
firefox --new-tab http://127.0.0.1:8000
stop
}

stop(){
#stop rtlsdr-airband
sudo killall rtl_airband
#stop the icecast2 server
service icecast2 stop
sleep 2
}

buildconf(){
DEVICE=$(zenity --forms --title="RTLSDR-Airband - Device Setup" \
--separator="," \
--text="Enter the SDR start-up parameters." \
--add-entry="Device Gain:" \
--add-entry="Device Center Frequency (Hz):" \
--add-entry="Device Freq Correction (ppm):" \
--add-entry="How many channels? (1 to 8)");

if [[ "$?" -ne "0" || -z "$?" ]]; then
    echo "something went wrong"
    stop
fi

echo $DEVICE

gain=$(awk -F, '{print $1}' <<<$DEVICE)
ctrfreq=$(awk -F, '{print $2}' <<<$DEVICE)
corr=$(awk -F, '{print $3}' <<<$DEVICE)
channels=$(awk -F, '{print $4}' <<<$DEVICE)

#top of the file, defining SDR tuning, etc
echo "# This is a minimalistic configuration file for RTLSDR-Airband.
# Just a single RTL dongle with two AM channels in multichannel mode.
# Each channel is sent to a single Icecast output. Settings are
# described in reference.conf.

devices:
({
  index = 0;
  gain = $gain;
  centerfreq = $ctrfreq;
  correction = $corr;
  channels:
  (" > /usr/local/etc/rtl_airband.conf

for (( n=1; n <= $channels; ++n ))
do

CHNLDATA=$(zenity --forms --title="RTLSDR-Airband - Channel $n Data" \
--separator="," \
--text="Enter the data for channel $n.
Frequencies must be within +/- 1.25 MHz 
of center frequency $ctrfreq. 

Example:   Frequency (Hz): 120600000
           Mode (am,fm:): am
           Mountpoint: apchwest
           Stream Name: Approach - West" \
--add-entry="Channel $n Frequency (Hz)" \
--add-entry="Channel $n Mode (am,fm):" \
--add-entry="Channel $n Mountpoint:" \
--add-entry="Channel $n Stream Name" \
--add-entry="Channel $n Genre" \
);

if [[ "$?" -ne "0" || -z "$?" ]]; then
    echo "something went wrong"
    stop
fi

freq=$(awk -F, '{print $1}' <<<$CHNLDATA)
mode=$(awk -F, '{print $2}' <<<$CHNLDATA)
mount=$(awk -F, '{print $3}' <<<$CHNLDATA)
stream=$(awk -F, '{print $4}' <<<$CHNLDATA)
genre=$(awk -F, '{print $5}' <<<$CHNLDATA)

comma=","
if (($n == $channels)); then
     comma=""
fi

# middle of the file, defining channels and outputs
echo "    {
      freq = $freq;
      mode = \"$mode\";
      outputs: (
        {
	  type = \"icecast\";
	  server = \"localhost\";
          port = 8000;
          mountpoint = \"$mount.mp3\";
          name = \"$stream\";
          genre = \"$genre\";
          username = \"source\";
	  password = \"skywave\";
	}
      );
    }$comma" >> /usr/local/etc/rtl_airband.conf

done

#bottom of the file
echo "  );
 }
);" >> /usr/local/etc/rtl_airband.conf

}

backupconf(){
cp -f /usr/local/etc/rtl_airband.conf /usr/local/etc/rtl_airband.conf.bak
}

restoreconf(){
cp -f /usr/local/etc/rtl_airband.conf.bak /usr/local/etc/rtl_airband.conf
}

ans=$(zenity --list --title "RTLSDR-Airband" --height 250 --width 500 --text \
"RTLSDR-Airband" --radiolist  --column "Pick" --column "Action" \
TRUE "Start RTLSDR-Airband" FALSE "Stop RTLSDR-Airband" \
FALSE "Set channels and start RTLSDR-Airband" FALSE "Backup the current config file." \
FALSE "Restore the config file from a backup.");

	if [  "$ans" = "Start RTLSDR-Airband" ]; then
		start0

	elif [  "$ans" = "Stop RTLSDR-Airband" ]; then 
		stop

	elif [  "$ans" = "Set channels and start RTLSDR-Airband" ]; then
		start1

	elif [  "$ans" = "Backup the current config file." ]; then
		backupconf

	elif [  "$ans" = "Restore the config file from a backup." ]; then
		restoreconf

	fi
