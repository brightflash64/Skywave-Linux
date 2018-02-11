#!/bin/bash

# Copyright (c) 2018 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


#Specify the rds data dump file
rdsdump="~redsea-rds.json"

#Redsea RDS Decoder via RTL-SDR
OUTPUT=$(zenity --forms --title="Redsea RDS decoder for FM Broadcasts" --text="Enter the SDR start-up parameters." \
--separator="," --add-entry="Center Frequency (MHz)" --add-entry="Freq Correction (ppm)" --add-entry="Gain Setting");

ctrfreq=$(awk -F, '{print $1}' <<<$OUTPUT)
corr=$(awk -F, '{print $2}' <<<$OUTPUT)
gain=$(awk -F, '{print $3}' <<<$OUTPUT)
mega=M

#start redsea
sh -c "rtl_fm -M fm -f ${ctrfreq}${mega} -l 0 -A std -p ${corr} -s 171k -g ${gain} -F 9 | redsea  --feed-through 2> ${rdsdump} | aplay -t raw -r 171000 -c 1 -f S16_LE -" &
sleep 3
gedit ${rdsdump}

#when finished, terminate the processes
killall -9 aplay
killall -9 redsea
killall -9 rtl_fm
exit
