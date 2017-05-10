#!/bin/sh
Encoding=UTF-8

ans=$(zenity  --list --height 680 --width 470 --text "WebSDR and OpenwebRX Servers" --radiolist  --column "Pick" --column "Action" \
TRUE "WebSDR - Online List" FALSE "OpenWebRX - Online List" FALSE "WebSDR, University of Twente, Netherlands" \
FALSE "OpenWebRX, OE4XLC, Allhau, Austria" FALSE "OpenWebRX, ZL/KF6VO, New Zealand" FALSE "OpenWebRX, SK3W, Sweden" \
FALSE "OpenWebRX, TF3ARI, Reykjavik, Iceland" FALSE "OpenWebRX, VE7AB, Victoria, BC, Canada" \
FALSE "OpenWebRX, JA1GJD/2, Aichi, Japan" FALSE "OpenWebRX, JA/EK0JA, Chiba, Japan" \
FALSE "OpenWebRX, San Jose, California, USA" FALSE "OpenWebRX, KD4HSO, Overland Park, Kansas, USA" \
FALSE "OpenWebRX, K2SDR, Sea Girt, New Jersey, USA" FALSE "OpenWebRX, W0AY, Stevensville, Montana, USA" \
FALSE "OpenWebRX, KH6ILT, Elida, Ohio, USA" FALSE "OpenWebRX, K1RA, Warrenton, Virginia, USA" \
FALSE "OpenWebRX, WA6OUR, Sammamish, Washington, USA" FALSE "WebSDR, N4DKD, Birmingham, Alabama, USA" \
FALSE "WebSDR, G4FPH, Stafford, UK" FALSE "WebSDR, Farnham, UK" FALSE "WebSDR, Grimsby, UK" \
FALSE "WebSDR, Peterborough, UK" FALSE "WebSDR, DJ3LE, Silberstedt, Germany" \
FALSE "WebSDR, SP3PGX, Zielona Gora, Poland" );

	if [  "$ans" = "WebSDR - Online List" ]; then
		firefox --new-tab http://websdr.org/

	elif [  "$ans" = "OpenWebRX - Online List" ]; then
		firefox --new-tab http://sdr.hu/

	elif [  "$ans" = "WebSDR, University of Twente, Netherlands" ]; then
		firefox --new-tab http://websdr.ewi.utwente.nl:8901/

	elif [  "$ans" = "OpenWebRX, OE4XLC, Allhau, Austria" ]; then
		firefox --new-tab http://www.websdr.at:8073/

	elif [  "$ans" = "OpenWebRX, ZL/KF6VO, New Zealand" ]; then
		firefox --new-tab http://kiwisdr.jks.com:8073/

	elif [  "$ans" = "OpenWebRX, SK3W, Sweden" ]; then
		firefox --new-tab http://kiwisdr.sk3w.se:8073/

	elif [  "$ans" = "OpenWebRX, TF3ARI, Reykjavik, Iceland" ]; then
		firefox --new-tab http://utvarp.com:8073/

	elif [  "$ans" = "OpenWebRX, VE7AB, Victoria, BC, Canada" ]; then
		firefox --new-tab http://kiwisdr.ece.uvic.ca:8073/

	elif [  "$ans" = "OpenWebRX, JA1GJD/2, Aichi, Japan" ]; then
		firefox --new-tab http://rio.f5.si:8073/

	elif [  "$ans" = "OpenWebRX, JA/EK0JA, Chiba, Japan" ]; then
		firefox --new-tab http://travelx.org:8073/

	elif [  "$ans" = "OpenWebRX, San Jose, California, USA" ]; then
		firefox --new-tab http://kiwisdr.lupine.org:8073/

	elif [  "$ans" = "OpenWebRX, KD4HSO, Overland Park, Kansas, USA" ]; then
		firefox --new-tab http://64.136.200.36:8073/

	elif [  "$ans" = "OpenWebRX, K2SDR, Sea Girt, New Jersey, USA" ]; then
		firefox --new-tab http://k2sdr.homelinux.com:8073/

	elif [  "$ans" = "OpenWebRX, W0AY, Stevensville, Montana, USA" ]; then
		firefox --new-tab http://ranova.port0.org:8073/

	elif [  "$ans" = "OpenWebRX, KH6ILT, Elida, Ohio, USA" ]; then
		firefox --new-tab http://65.29.112.189:8073/

	elif [  "$ans" = "OpenWebRX, K1RA, Warrenton, Virginia, USA" ]; then
		firefox --new-tab http://kiwisdr.k1ra.us:8073/

	elif [  "$ans" = "OpenWebRX, WA6OUR, Sammamish, Washington, USA" ]; then
		firefox --new-tab http://73.193.84.112:8073/

	elif [  "$ans" = "WebSDR, N4DKD, Birmingham, Alabama, USA" ]; then
		firefox --new-tab http://n4dkd.asuscomm.com:8901/

	elif [  "$ans" = "WebSDR, G4FPH, Stafford, UK" ]; then
		firefox --new-tab http://www.160m.net/

	elif [  "$ans" = "WebSDR, Farnham, UK" ]; then
		firefox --new-tab http://websdr.suws.org.uk/

	elif [  "$ans" = "WebSDR, Grimsby, UK" ]; then
		firefox --new-tab http://grimsbysdr.ddns.net:8073/

	elif [  "$ans" = "WebSDR, Peterborough, UK" ]; then
		firefox --new-tab http://cambs-sdr.no-ip.org:8901/

	elif [  "$ans" = "WebSDR, DJ3LE, Silberstedt, Germany" ]; then
		firefox --new-tab http://dj3le.spdns.de:8901/

	elif [  "$ans" = "WebSDR, SP3PGX, Zielona Gora, Poland" ]; then
		firefox --new-tab http://websdr.sp3pgx.uz.zgora.pl:8901/

	fi
