#!/bin/sh
Encoding=UTF-8

start() {
M=M
rtl_fm -M fm -f $freq$M -l 0 -A std -p 0 -s 171k -g 26 -F 9 | /usr/local/bin/redsea -e | aplay -t raw -r 171000 -c 1 -f S16_LE
}

echo '\nRedsea RDS decoder for FM Broadcasts'
read -p 'Please enter a frequency in MHz: ' freq

start
