#!/bin/bash

# Copyright (c) 2018 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

#for rtl-sdr reception in ghpsdr3-alex / QtRadio
runme() {
mate-terminal -e 'rtlsdr-server -d3 -g160 -s250000' &
sleep 2
sh -c 'dspserver --lo 9000' &
sleep 2
QtRadio 127.0.0.1
killall rtlsdr-server
killall dspserver
}

read -p '

Create SSL keys for this session? (Y,n) ' choice1
case "$choice1" in 
  y|Y ) 
  openssl genrsa -out pkey 2048
  openssl req -new -key pkey -out cert.req
  openssl x509 -req -days 365 -in cert.req -signkey pkey -out cert
runme
  echo ""
  echo ""
;;
  n|N )
runme
  echo ""
  echo ""
;;
esac
