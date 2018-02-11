#!/bin/bash

# Copyright (c) 2018 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

#OpenWebRX for RTL-SDR Devices
cd /usr/local/sbin/openwebrx/

start() {
cp /usr/local/sbin/openwebrx/config_webrx.orig /usr/local/sbin/openwebrx/config_webrx.py
#Edit the configuration
sed -i "
     43s/.*/receiver_name=\"Openwebrx in Skywave Linux\"/;
     44s/.*/receiver_location=\"City, Country\"/;
     45s/.*/receiver_qra=\"GRIDLOC\"/;
     51s/.*/photo_height=316/;
     52s/.*/photo_title=\"Scenery from the Interneational Space Station\"/;
     75s/.*/center_freq = $ctrfreq$mega/;
     76s/.*/rf_gain = $gain/;
     77s/.*/ppm = $corr/;
     79s/.*/audio_compression=\"none\"/;
     106s/.*/start_rtl_command=\"rtl_sdr -s {samp_rate} -f {center_freq} -p {ppm} -g {rf_gain} -\".format(rf_gain=rf_gain, center_freq=center_freq, samp_rate=samp_rate, ppm=ppm)/;
     160s/.*/client_audio_buffer_size = 10/;
     166s/.*/start_mod = \"$mode\"/;
     178s/.*/waterfall_min_level = -50/;
     179s/.*/waterfall_max_level = -15/" /usr/local/sbin/openwebrx/config_webrx.py

#Start OpenWebRX
python ./openwebrx.py & firefox --new-tab http://localhost:8073/
}

OUTPUT=$(zenity --forms --title="OpenWebRX - RTL-SDR" --text="Enter the SDR start-up parameters." \
--separator="," --add-entry="Center Frequency (MHz)" --add-entry="Mode (am,fm,usb,lsb,cw)" --add-entry="Freq Correction (ppm)" --add-entry="Gain Setting" --add-entry="List on SDR.hu? (yes/no)");

if [[ "$?" -ne "0" ]]; then
    echo "Something went wrong!!!!!!"
    exit
fi

ctrfreq=$(awk -F, '{print $1}' <<<$OUTPUT)
mode=$(awk -F, '{print $2}' <<<$OUTPUT)
corr=$(awk -F, '{print $3}' <<<$OUTPUT)
gain=$(awk -F, '{print $4}' <<<$OUTPUT)
status=$(awk -F, '{print $5}' <<<$OUTPUT)
mega=e6

if [ "$status" == "yes" ]; then
key=$(zenity --forms --title="OpenWebRX - RTL-SDR" \
--add-entry="SDR.hu a ccount key:");

    if [[ "$?" -ne "0" || -z "$key" ]]; then
        echo "Something went wrong!!!!!!"
        exit

    else
   status="True"
     sed -i "
     65s/.*/sdrhu_key = \"$key\"/;
     67s/.*/sdrhu_public_listing = $status/;" /usr/local/sbin/openwebrx/config_webrx.py
   fi

else
   status="False"
   sed -i "
   67s/.*/sdrhu_public_listing = $status/;" /usr/local/sbin/openwebrx/config_webrx.py
fi

start
killall -9 openwebrx rtl_mus rtl_sdr csdr
pkill -f "python ./openwebrx.py"
exit
