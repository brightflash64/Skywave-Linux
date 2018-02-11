#!/bin/bash

# Copyright (c) 2018 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

#Decode ACARS and VDL Mode 2, using acarsdec and dumpvdl2.  Both
#are capable of simultaneous multichannel reception, though each
#application must run one at a time on a device.

#-------------Set Variables----------------------------------------
#Designate up to eight ACARS frequencies, specified in Hz:
#Designate up to eight ACARS frequencies, specified in Hz:
afreq=(131.125 131.450 131.525 131.550 131.725 131.850);

#Designate up to eight vdl mode 2 frequencies, specified in Hz:
vfreq=(136725000 136775000 136875000 136975000);
#-------------There be dragons below this line---------------------
#Specify the ACARS database file:
acarslog="~/acarsserv.db"
#Specify the VDL2 dump file:
vdl2log="~/vdl2.log"
touch $vdl2log

ans=$(zenity  --list  --height 350 --width 350 --title="RTLSDR Multichannel Digital Decoders" \
--text="ACARSdec and DumpVDL2 are capable of:
-- ACARSdec decodes ACARS
-- DumpVDL2 decodes VDL Mode 2
-- Up to 8 Channels at once
-- Error detection and correction
-- Can log messages to a database
-- RTL-SDR (or I/Q file input)
-- Edit the script to change freqs
" \
--radiolist --column "Select" TRUE "Run ACARSdec" FALSE "Run DumpVDL2" \
FALSE "Stop ACARSdec" FALSE "Stop DumpVDL2" --column "Action");

if [  "$ans" = "Run ACARSdec" ]; then
      killall -9 acarsdec
      killall -9 acarsserv
      PARAMS=$(zenity --forms --title="Device Parameters" --separator="," \
      --add-entry="Freq Correction (ppm)" --add-entry="Gain");

            ppm=$(awk -F, '{print $1}' <<<$PARAMS)
            gain=$(awk -F, '{print $2}' <<<$PARAMS)

     cd /usr/local/sbin/acarsdec
     sh -c "./acarsserv -v -b ${acarslog} -s" &
     sleep 3
     sh -c "./acarsdec -v -o 2 -N 127.0.0.1:5555 -g ${gain}0 -p 0${ppm} -r 0 ${afreq[*]}" &
     sleep 3
     sh -c "sqlitebrowser ${acarslog}" &


elif [  "$ans" = "Run DumpVDL2" ]; then
      killall -9 dumpvdl2
      touch $vdl2log
      PARAMS=$(zenity --forms --title="Device Parameters" --separator="," \
      --add-entry="Freq Correction (ppm)" --add-entry="Gain")

            ppm=$(awk -F, '{print $1}' <<<$PARAMS)
            gain=$(awk -F, '{print $2}' <<<$PARAMS)

       sh -c "dumpvdl2 --rtlsdr 0 --gain ${gain} --correction ${ppm} --output-file ${vdl2log} ${vfreq[*]}"

elif [  "$ans" = "Stop ACARSdec" ]; then
      killall -9 acarsdec
      killall -9 acarsserv
      killall -9 sqlitebrowser
      exit
      
elif [  "$ans" = "Stop DumpVDL2" ]; then
      killall -9 dumpvdl2
      exit

fi
