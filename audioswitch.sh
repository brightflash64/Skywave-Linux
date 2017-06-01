#!/bin/bash
#Audio device switcher for pulseaudio

setdevice() {
# edit the pulseaudio defaults
sudo sed -i "47s/.*/load-module module-alsa-sink device=$hardware sink_name=processed_output/" /etc/pulse/default.pa

#restart the audio system
echo "\n...Restarting Pulseaudio..."
pulseaudio -k
echo "

Testing the speakers.   Enter [Ctrl-C] to exit!

"
speaker-test -t sine -c 2
}

# ask for the devired soundcard and device
ans=$(zenity --list --height 290 --width 470 --title="Pulseaudio Device Switcher" --text "Select your hardware then listen for a tone." --radiolist  --column "Pick" --column "Action" \
TRUE "Soundcard 0, Device 0" FALSE "Soundcard 0, Device 1" FALSE "Soundcard 1, Device 0" \
FALSE "Soundcard 1, Device 1" FALSE "Soundcard 2, Device 0" FALSE "Soundcard 2, Device 1");

	if [  "$ans" = "Soundcard 0, Device 0" ]; then
		hardware="hw:0,0";setdevice

	elif [  "$ans" = "Soundcard 0, Device 1" ]; then
		hardware="hw:0,1";setdevice

	elif [  "$ans" = "Soundcard 1, Device 0" ]; then
		hardware="hw:1,0";setdevice

	elif [  "$ans" = "Soundcard 1, Device 1" ]; then
		hardware="hw:1,1";setdevice

	elif [  "$ans" = "Soundcard 2, Device 0" ]; then
		hardware="hw:2,0";setdevice

	elif [  "$ans" = "Soundcard 2, Device 1" ]; then
		hardware="hw:2,1";setdevice

	fi

exit
