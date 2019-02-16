#!/bin/bash

# Copyright (c) 2019 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
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
     70s/.*/fft_size = 8192/;
     74s/.*/samp_rate = 62500/;
     75s/.*/center_freq = 31250/;
     76s/.*/rf_gain = $gain/;
     77s/.*/ppm = $corr/;
     79s/.*/audio_compression = \"none\"/;
     80s/.*/fft_compression = \"none\"/;
     106s/.*/#start_rtl_command = \"rtl_sdr -s {samp_rate} -f {center_freq} -p {ppm} -g {rf_gain} -\".format(rf_gain=rf_gain, center_freq=center_freq, samp_rate=samp_rate, ppm=ppm)/;
     107s/.*/#format_conversion = \"csdr convert_u8_f\"/;
     142s/.*/soapy_device_query = \"driver=$driver,$devkey\"/;
     149s/.*/start_rtl_command = \"rx_fm -M fm -f $ctrfreq$mega -d {device_query} -p {ppm} -s 250k -g {rf_gain} - | csdr convert_s16_f | csdr shift_addition_cc -0.25 | csdr fir_decimate_cc 2 0.002 | csdr gain_ff 2 \".format(device_query=soapy_device_query, rf_gain=rf_gain, center_freq=center_freq, samp_rate=samp_rate, ppm=ppm)/;
     150s/.*/format_conversion = \"\"/;
     107s/.*/format_conversion=\"\"/;
     108s/.*/real_input = True/;
     160s/.*/client_audio_buffer_size = 10/;
     166s/.*/start_mod = \"$mode\"/;
     178s/.*/waterfall_min_level = -70/;
     179s/.*/waterfall_max_level = -15/" /usr/local/sbin/openwebrx/config_webrx.py

#Start OpenWebRX
python2 ./openwebrx.py & firefox --new-tab http://localhost:8073/
}

OUTPUT=$(zenity --forms --title="OpenWebRX - FM Subcarriers" \
--text="Enter the SDR start-up parameters
reported by \"SoapySDRUtil --find\"." \
--separator="," \
--add-entry="SoapySDR Device Driver (e.g. rtlsdr):" \
--add-entry="SoapySDR Device Key (e.g. rtl=0):" \
--add-entry="RF Center Frequency (MHz)" \
--add-entry="Freq Correction (ppm)" \
--add-entry="Gain Setting" \
--add-entry="Subcarrier Mode (am,fm,usb,lsb,cw)" \
--add-entry="List on SDR.hu? (yes/no)");

if [[ "$?" -ne "0" ]]; then
    echo "Something went wrong!!!!!!"
    exit
fi

driver=$(awk -F, '{print $1}' <<<$OUTPUT)
devkey=$(awk -F, '{print $2}' <<<$OUTPUT)
ctrfreq=$(awk -F, '{print $3}' <<<$OUTPUT)
corr=$(awk -F, '{print $4}' <<<$OUTPUT)
gain=$(awk -F, '{print $5}' <<<$OUTPUT)
mode=$(awk -F, '{print $6}' <<<$OUTPUT)
status=$(awk -F, '{print $7}' <<<$OUTPUT)
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
killall -9 openwebrx ncat nmux rtl_mus rtl_sdr csdr rx_sdr
pkill -f "python2 ./openwebrx.py"
exit
