#!/bin/sh

no() {
gnome-terminal -e 'softrock --iq --samplerate 48000' &
sleep 2
gnome-terminal -e 'dspserver --lo 9000' &
sleep 2
QtRadio
killall softrock
killall dspserver
}

yes() {
gnome-terminal -e 'softrock --iq --si570 --samplerate 48000' &
sleep 2
gnome-terminal -e 'dspserver --lo 9000' &
sleep 2
QtRadio
killall softrock
killall dspserver
}

echo ""
echo "Enable networked audio with the PulseAudio Preferences Application."
echo ""
read -p "Create keys for this session? (Y,n) " choice1
case "$choice1" in 
  y|Y ) 
  openssl genrsa -out pkey 2048
  openssl req -new -key pkey -out cert.req
  openssl x509 -req -days 365 -in cert.req -signkey pkey -out cert
  echo ""
  echo "Okay, one more question..."
  echo ""
;;
  n|N )
  echo ""
  echo "Okay, one more question..."
  echo ""
;;
esac

read -p "Is your Softrock using an Si570 Tuner? (y/n)? " choice2
case "$choice2" in 
  y|Y ) yes;;
  n|N ) no;;
  * )
  echo ""
  echo "Please reply yes or no."
  echo ""
;;
esac


