#!/bin/bash

# Copyright (c) 2018 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

#OpenWebRX subcarrier receiver for RTL-SDR Devices
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
     74s/.*/samp_rate = 75000/;
     75s/.*/center_freq = 37500/;
     76s/.*/rf_gain = $gain/;
     77s/.*/ppm = $corr/;
     79s/.*/audio_compression=\"none\"/;
     106s/.*/start_rtl_command=\"rtl_fm -M fm -f $ctrfreq$mega -l 0 -A fast -p $corr -s 300k -g 16 - | csdr convert_s16_f | csdr shift_addition_cc -0.25 | csdr fir_decimate_cc 2 0.002 | csdr gain_ff 2 \"/;
     107s/.*/format_conversion=\"\"/;
     108s/.*/real_input = True/;
     160s/.*/client_audio_buffer_size = 10/;
     166s/.*/start_mod = \"$mode\"/;
     178s/.*/waterfall_min_level = -75/;
     179s/.*/waterfall_max_level = -30/" /usr/local/sbin/openwebrx/config_webrx.py

#Start OpenWebRX
python ./openwebrx.py & firefox --new-tab http://localhost:8073/
}

OUTPUT=$(zenity --forms --title="OpenWebRX - FM Subcarriers" --text="Enter the SDR start-up parameters." \
--separator="," --add-entry="Center Frequency (MHz)" --add-entry="Mode (am,fm,usb,lsb,cw)" --add-entry="Freq Correction (ppm)" --add-entry="Gain Setting");

if [[ "$?" -ne "0" ]]; then
    echo "Something went wrong!!!!!!"
    exit
fi

ctrfreq=$(awk -F, '{print $1}' <<<$OUTPUT)
mode=$(awk -F, '{print $2}' <<<$OUTPUT)
corr=$(awk -F, '{print $3}' <<<$OUTPUT)
gain=$(awk -F, '{print $4}' <<<$OUTPUT)
mega=e6

start
killall -9 openwebrx rtl_mus rtl_fm csdr
pkill -f "python ./openwebrx.py"
exit
