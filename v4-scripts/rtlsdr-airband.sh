#!/bin/bash

# Copyright (c) 2019 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# Capture a wide RF bandwidth and operate a multichannel SDR receiver.

start0(){
#start rtlsdr-airband on PulseAudio
cp -f /usr/local/etc/rtl_airband-pulse.conf /usr/local/etc/rtl_airband.conf
/usr/local/bin/rtl_airband &
WINDOW=$(zenity --info --height 100 --width 350 \
--title="Multichannel Voice - Running" \
--text="The multichannel receiver is running.
To stop, use this application and select \"Stop Multichannel Voice.\""
);
}

start1(){
#start rtlsdr-airband on the icecast server
cp -f /usr/local/etc/rtl_airband-icecast.conf /usr/local/etc/rtl_airband.conf
service icecast2 start
sleep 3
#start rtlsdr-airband
/usr/local/bin/rtl_airband &
sleep 3
firefox --new-tab http://127.0.0.1:8000
stop
}

start2(){
#build the config file for using PulseAudio
buildconf0
#start rtlsdr-airband
/usr/local/bin/rtl_airband &
WINDOW=$(zenity --info --height 100 --width 350 \
--title="Multichannel Voice - Running" \
--text="The multichannel receiver is running.
To stop, use this application and select \"Stop Multichannel Voice.\""
);
}

start3(){
#build the config file for using IceCast
buildconf1
#start rtlsdr-airband
service icecast2 start
sleep 3
#start rtlsdr-airband
/usr/local/bin/rtl_airband &
sleep 3
firefox --new-tab http://127.0.0.1:8000
}

stop(){
#stop rtlsdr-airband
killall rtl_airband
#stop the icecast2 server
service icecast2 stop
sleep 2
exit
}

buildconf0(){
DEVICE=$(zenity --forms --height 300 --width 500 \
--title="Multichannel Voice - Configure For PulseAudio" \
--separator="," \
--text="Output will be sent to PulseAudio.
Enter the SDR start-up parameters
reported by \"SoapySDRUtil --find\"." \
--add-entry="SoapySDR Device Driver (e.g. rtlsdr):" \
--add-entry="SoapySDR Device Key (e.g. rtl=0):" \
--add-entry="Device Gain:" \
--add-entry="Device Center Frequency (MHz):" \
--add-entry="Device Freq Correction (ppm):" \
--add-entry="Number of channels (1 or more):" \
--add-entry="Stream Name:" \
--add-entry="Genre:" \
);

if [[ "$?" -ne "0" || -z "$?" ]]; then
    echo "something went wrong"
    stop
fi

driver=$(awk -F, '{print $1}' <<<$DEVICE)
devkey=$(awk -F, '{print $2}' <<<$DEVICE)
gain=$(awk -F, '{print $3}' <<<$DEVICE)
ctrfreq=$(awk -F, '{printf "%8.3f\n", $4}' <<<$DEVICE)
corr=$(awk -F, '{print $5}' <<<$DEVICE)
channels=$(awk -F, '{print $6}' <<<$DEVICE)
streamname=$(awk -F, '{print $7}' <<<$DEVICE)
genre=$(awk -F, '{print $8}' <<<$DEVICE)

#top of the file, defining SDR tuning, etc
echo '# This is a sample configuration file for RTLSDR-Airband.
# Just a single SDR with multiple AM channels in multichannel mode.
# Each channel is sent to PulseAusio. Settings are described
# in reference.conf.

mixers: {
  mixer1: {
    outputs: (
        {
	      type = "pulse";
          stream_name = "'$streamname'";
          genre = "'$genre'";
	}
    );
  }
};

devices:
({
  type = "soapysdr";
  device_string = "driver='$driver','$devkey'";
  gain = '$gain';
  centerfreq = '$ctrfreq';
  correction = '$corr';
  channels:
  (' > /usr/local/etc/rtl_airband.conf

for (( n=1; n <= $channels; ++n ))
do

CHNLDATA=$(zenity --forms --title="Multichannel Voice - Channel $n Data" \
--separator="," \
--text="Enter the data for channel $n.
Frequencies must be within +/- 1.25 MHz 
of center frequency $ctrfreq. 

Example:   Frequency (MHz): 120.6
           Mode (am,fm:): am" \
--add-entry="Channel $n Frequency (MHz):" \
--add-entry="Channel $n Mode (am,fm):" \
);

if [[ "$?" -ne "0" || -z "$?" ]]; then
    echo "something went wrong"
    stop
fi

freq=$(awk -F, '{printf "%8.3f\n", $1}' <<<$CHNLDATA)
mode=$(awk -F, '{print $2}' <<<$CHNLDATA)

comma=","
if (($n == $channels)); then
     comma=""
fi

# for multiple channels use stereo
if [[ $(( $n % 2 )) -eq 0 ]]; 
	then bal="+0.6" ;
	else bal="-0.6" ;
fi

# for one channel use mono
if (($channels == 1));
	then bal="0.0"
fi
   
# middle of the file, defining channels and outputs
echo '    {
      freq = '$freq';
      mode = "'$mode'";
      outputs: (
    {
	  type = "mixer";
	  name = "mixer1";
	  balance = '$bal';
	}
      );
    }'$comma >> /usr/local/etc/rtl_airband.conf

done

#bottom of the file
echo "  );
 }
);" >> /usr/local/etc/rtl_airband.conf

}

buildconf1(){
DEVICE=$(zenity --forms --height 300 --width 500 \
--title="Multichannel Voice - Configure For Icecast" \
--separator="," \
--text="Output will be sent to Icecast.
Enter the SDR start-up parameters
reported by \"SoapySDRUtil --find\"." \
--add-entry="SoapySDR Device Driver (e.g. rtlsdr):" \
--add-entry="SoapySDR Device Key (e.g. rtl=0):" \
--add-entry="Device Gain:" \
--add-entry="Device Center Frequency (MHz):" \
--add-entry="Device Freq Correction (ppm):" \
--add-entry="Number of channels (1 or more):" \
--add-entry="Stream Name:" \
--add-entry="Genre:" \
);

if [[ "$?" -ne "0" || -z "$?" ]]; then
    echo "something went wrong"
    stop
fi

driver=$(awk -F, '{print $1}' <<<$DEVICE)
devkey=$(awk -F, '{print $2}' <<<$DEVICE)
gain=$(awk -F, '{print $3}' <<<$DEVICE)
ctrfreq=$(awk -F, '{printf "%8.3f\n", $4}' <<<$DEVICE)
corr=$(awk -F, '{print $5}' <<<$DEVICE)
channels=$(awk -F, '{print $6}' <<<$DEVICE)
streamname=$(awk -F, '{print $7}' <<<$DEVICE)
genre=$(awk -F, '{print $8}' <<<$DEVICE)

#top of the file, defining SDR tuning, etc
echo '# This is a sample configuration file for RTLSDR-Airband.
# Just a single SDR with multiple AM channels in multichannel mode.
# Each channel is sent to the Icecast server. Settings are described
# in reference.conf.

mixers: {
  mixer1: {
    outputs: (
        {
	      type = "icecast";
	      server = "localhost";
          port = 8000;
          mountpoint = "mixer1.mp3";
          stream_name = "'$streamname'";
          genre = "'$genre'";
          username = "source";
          password = "skywave";
	}
    );
  }
};

devices:
({
  type = "soapysdr";
  device_string = "driver='$driver','$devkey'";
  gain = '$gain';
  centerfreq = '$ctrfreq';
  correction = '$corr';
  channels:
  (' > /usr/local/etc/rtl_airband.conf

for (( n=1; n <= $channels; ++n ))
do

CHNLDATA=$(zenity --forms --title="RTLSDR-Airband - Channel $n Data" \
--separator="," \
--text="Enter the data for channel $n.
Frequencies must be within +/- 1.25 MHz 
of center frequency $ctrfreq. 

Example:   Frequency (MHz): 120.6
           Mode (am,fm:): am" \
--add-entry="Channel $n Frequency (MHz):" \
--add-entry="Channel $n Mode (am,fm):" \
);

if [[ "$?" -ne "0" || -z "$?" ]]; then
    echo "something went wrong"
    stop
fi

freq=$(awk -F, '{printf "%8.3f\n", $1}' <<<$CHNLDATA)
mode=$(awk -F, '{print $2}' <<<$CHNLDATA)

comma=","
if (($n == $channels)); then
     comma=""
fi

# for multiple channels use stereo
if [[ $(( $n % 2 )) -eq 0 ]]; 
	then bal="+0.6" ;
	else bal="-0.6" ;
fi

# for one channel use mono
if (($channels == 1));
	then bal="0.0"
fi

# middle of the file, defining channels and outputs
echo '{
      freq = '$freq';
      mode = "'$mode'";
      outputs: (
    {
	  type = "mixer";
	  name = "mixer1";
	  balance = '$bal';
	}
      );
    }'$comma >> /usr/local/etc/rtl_airband.conf

done

#bottom of the file
echo '  );
 }
);' >> /usr/local/etc/rtl_airband.conf
}

backupconf(){
cp -f /usr/local/etc/rtl_airband.conf /usr/local/etc/rtl_airband.conf.bak
}

restoreconf(){
cp -f /usr/local/etc/rtl_airband.conf.bak /usr/local/etc/rtl_airband.conf
}

ans=$(zenity --list --title "Multichannel Voice" --height 400 --width 500 \
--text "Multichannel Voice functions:
--Uses SoapySDR drivers
--Simultaneous multichannel demodulation
--Set demodulation independently per channel
--Stereo mixing for for multiple channels
--Softwaare powered by \"RTLSDR-Airband\"
" \
--radiolist  --column "Pick" --column "Action" \
TRUE "Start Multichannel Voice (PulseAudio)" \
FALSE "Start Multichannel Voice (Icecast)" \
FALSE "Set channels and start Multichannel Voice (PulseAudio)" \
FALSE "Set channels and start Multichannel Voice (Icecast)" \
FALSE "Backup the current config file." \
FALSE "Restore the config file from a backup." \
FALSE "Stop Multichannel Voice" \
);

	if [  "$ans" = "Start Multichannel Voice (PulseAudio)" ]; then
		start0

	elif [  "$ans" = "Start Multichannel Voice (Icecast)" ]; then
		start1

	elif [  "$ans" = "Set channels and start Multichannel Voice (PulseAudio)" ]; then
		start2

	elif [  "$ans" = "Set channels and start Multichannel Voice (Icecast)" ]; then
		start3

	elif [  "$ans" = "Backup the current config file." ]; then
		backupconf

	elif [  "$ans" = "Restore the config file from a backup." ]; then
		restoreconf

	elif [  "$ans" = "Stop Multichannel Voice" ]; then 
		stop

	fi

