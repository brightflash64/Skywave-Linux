#!/bin/bash
#OpenWebRX for RTL-SDR Devices
start() {
cp /usr/local/sbin/openwebrx/config_webrx.orig /usr/local/sbin/openwebrx/config_webrx.py
#Edit the configuration
sed -i "
     43s/.*/receiver_name=\"Openwebrx in Skywave Linux\"/;
     44s/.*/receiver_location=\"City, Country\"/;
     45s/.*/receiver_qra=\"GRIDLOC\"/;
     51s/.*/photo_height=316/;
     52s/.*/photo_title=\"Scenery from the Interneational Space Station\"/;
     73s/.*/samp_rate = 100000/;
     75s/.*/center_freq = 50000/;
     76s/.*/rf_gain = 29/;
     77s/.*/ppm = $corr/;
     79s/.*/audio_compression=\"none\"/;
     94s/.*/start_rtl_command=\"rtl_fm -M fm -f $ctrfreq$mega -l 0 -A std -p $corr -s 400k -g 30 -F 9 - | csdr convert_s16_f | csdr shift_addition_cc -0.25 | csdr fir_decimate_cc 2 0.005\"/;
     95s/.*/format_conversion=\"\"/;
     96s/.*/real_input = True/;
     137s/.*/client_audio_buffer_size = 10/;
     143s/.*/start_mod = \"$mode\"/;
     150s/.*/waterfall_min_level = -80/;
     151s/.*/waterfall_max_level = -25/" /usr/local/sbin/openwebrx/config_webrx.py

#Start OpenWebRX
cd /usr/local/sbin/openwebrx/
python ./openwebrx.py & firefox --new-tab http://localhost:8073/
}

OUTPUT=$(zenity --forms --title="OpenWebRX - RTL-SDR" --text="Enter the SDR start-up parameters." \
--separator="," --add-entry="Center Frequency (MHz)" --add-entry="Mode (am,fm,usb,lsb,cw)" --add-entry="Freq Correction (ppm)")

if ((accepted != 0)); then
    echo "something went wrong"
    exit 1
fi

ctrfreq=$(awk -F, '{print $1}' <<<$OUTPUT)
mode=$(awk -F, '{print $2}' <<<$OUTPUT)
corr=$(awk -F, '{print $3}' <<<$OUTPUT)
mega=e6

start
killall -9 openwebrx rtl_mus rtl_fm csdr
pkill -f "python ./openwebrx.py"
exit
