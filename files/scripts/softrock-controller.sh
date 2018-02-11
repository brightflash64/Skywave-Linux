#!/bin/bash

# Copyright (c) 2018 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

no() {
sh -c 'softrock --iq --samplerate 48000' &
start
}

yes() {
sh -c 'softrock --iq --si570 --samplerate 48000' &
start
}

start() {
sleep 2
sh -c 'dspserver --lo 9000' &
sleep 2
QtRadio
killall softrock
killall dspserver
}

read -p '
Enable networked audio with the PulseAudio Preferences application.
(Look in System > Preferences > Other > PulseAudio Preferences)

Create SSL keys for this session? (Y,n): ' choice1
case "$choice1" in 
  y|Y ) 
  openssl genrsa -out pkey 2048
  openssl req -new -key pkey -out cert.req
  openssl x509 -req -days 365 -in cert.req -signkey pkey -out cert
;;
esac

read -p '

For fixed frequency QSDs, use the SubRX to tune within the passband.
For tunable QSDs, set it to your desired center frequency and use the main RX.

Is your Softrock using an Si570 Tuner? (y/n): ' choice2
case "$choice2" in 
  y|Y ) yes;;
  n|N ) no;;
  * ) read -p 'Please reply "yes" or "no": ' X
;;
esac

