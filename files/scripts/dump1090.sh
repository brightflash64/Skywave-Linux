#!/bin/bash
start1() {
cp /usr/local/sbin/dump1090/public_html/config.js.orig /usr/local/sbin/dump1090/public_html/config.js
# edit the config file with actual lat/lon
sed -i "
     14s/.*/CONST_CENTERLAT = $latitude;/ ;
     15s/.*/CONST_CENTERLON = $longitude;/ ;
     28s/.*/SiteLat = $latitude;/ ;
     29s/.*/SiteLon = $longitude;/" /usr/local/sbin/dump1090/public_html/config.js

# run dump1090
cd /usr/local/sbin/dump1090/
./dump1090 --net --interactive --phase-enhance --gain -10 --lat $latitude --lon $longitude --ppm $ppm &
firefox --new-tab http://127.0.0.1:8080
}

start2() {
cp /usr/local/sbin/dump1090_sdrplus/gmap.html.orig /usr/local/sbin/dump1090_sdrplus/gmap.html
# edit gmap.html to enter actual lat/lon
sed -i "
     42s/.*/    CenterLat=$latitude;/ ;
     43s/.*/    CenterLon=$longitude;/" /usr/local/sbin/dump1090_sdrplus/gmap.html

# run dump1090
cd /usr/local/sbin/dump1090_sdrplus/
./dump1090 --net --interactive --aggressive &
firefox --new-tab http://127.0.0.1:8080
}

OUTPUT=$(zenity --forms --title="Dump1090" --text="Enter the Dump1090 start-up parameters. \nFor example, in New York and a 30 ppm correction you enter 40.7, -74.0, and 30" \
--separator="," --add-entry="Latitude (degrees.decimals)" --add-entry="Longitude (degrees.decimals)" \
--add-entry="Freq Correction (ppm)" --add-entry="Using Airspy, HackRF, or SDRPlay? (y/n)")

if ((accepted != 0)); then
    echo "something went wrong"
    exit 1
fi

latitude=$(awk -F, '{print $1}' <<<$OUTPUT)
longitude=$(awk -F, '{print $2}' <<<$OUTPUT)
ppm=$(awk -F, '{print $3}' <<<$OUTPUT)
type=$(awk -F, '{print $4}' <<<$OUTPUT)

if [ "$type" = "y" ]; then
    start2
else
    start1
fi

killall -9 dump1090
