#!/bin/bash
#OpenWebRX for SDRPlay Devices
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
     79s/.*/audio_compression=\"none\"/;
     94s/.*/#start_rtl_command=\"rtl_sdr -s {samp_rate} -f {center_freq} -p {ppm} -g {rf_gain} -\".format(rf_gain=rf_gain, center_freq=center_freq, samp_rate=samp_rate, ppm=ppm)/;
     115s/.*/samp_rate = $samplerate/;
     116s/.*/start_rtl_command=\"arecord -f S16_LE -r {samp_rate} -c2 -\".format(samp_rate=samp_rate)/;
     117s/.*/format_conversion=\"csdr convert_s16_f | csdr gain_ff 30\"/;
     137s/.*/client_audio_buffer_size = 10/;
     143s/.*/start_mod = \"$mode\"/;
     150s/.*/waterfall_min_level = -80/;
     151s/.*/waterfall_max_level = -10/" /usr/local/sbin/openwebrx/config_webrx.py

#Start OpenWebRX
cd /usr/local/sbin/openwebrx/
python ./openwebrx.py & firefox --new-tab http://localhost:8073/
}

OUTPUT=$(zenity --forms --title="OpenWebRX - Soundcard" --text="Enter the SDR start-up parameters." \
--separator="," --add-entry="Frequency (MHz)" --add-entry="Mode (am,fm,usb,lsb,cw)" --add-entry="Samplerate (44100,48000,96000,192000)")

if ((accepted != 0)); then
    echo "something went wrong"
    exit 1
fi

ctrfreq=$(awk -F, '{print $1}' <<<$OUTPUT)
mode=$(awk -F, '{print $2}' <<<$OUTPUT)
samplerate=$(awk -F, '{print $3}' <<<$OUTPUT)
mega=e6

start
killall -9 openwebrx rtl_mus rtl_sdr csdr
pkill -f "python ./openwebrx.py"
exit
