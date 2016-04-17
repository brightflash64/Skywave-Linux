#!/bin/sh
Encoding=UTF-8

start() {
cd /usr/local/bin/
perl ./redsea.pl $freq
}


echo 'Redsea RDS decoder for FM Broadcasts
  '
read -p 'Please enter a frequency in MHz: ' freq

start
