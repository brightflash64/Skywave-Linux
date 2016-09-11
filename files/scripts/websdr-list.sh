#!/bin/sh
Encoding=UTF-8

ans=$(zenity  --list --height 475 --width 420 --text "WebSDR and OpenwebRX Servers" --radiolist  --column "Pick" --column "Action" \
TRUE "WebSDR - Online List" FALSE "OpenWebRX - Online List" FALSE "WebSDR, University of Twente (NL)" \
FALSE "OpenWebRX, OE4XLC, Allhau, Austria" FALSE "OpenWebRX, ZL/KF6VO, New Zealand" FALSE "OpenWebRX, SK3W, Sweden" \
FALSE "OpenWebRX, VE7AB, Victoria, BC (CA)" FALSE "OpenWebRX, KD4HSO, Overland Park, Kansas (USA)" \
FALSE "WebSDR, K2SDR, New Jersey (USA)" FALSE "WebSDR, G4FPH, Stafford (UK)" \
FALSE "WebSDR, N4DKD, Alabama (USA)" FALSE "WebSDR, SP3PGX, Zielona Gora, Poland" FALSE "WebSDR, Peterborough (UK)" \
FALSE "WebSDR, DG0KF, Greifswald, (DE)" FALSE "WebSDR, Silec, Poland" FALSE "OpenWebRX, PA3HEA, Zoetermeer (NL)" \
FALSE "WebSDR, W3ISZ, California (USA)");

	if [  "$ans" = "WebSDR - Online List" ]; then
		firefox --new-tab http://websdr.org/

	elif [  "$ans" = "OpenWebRX - Online List" ]; then
		firefox --new-tab http://sdr.hu/

	elif [  "$ans" = "WebSDR, University of Twente (NL)" ]; then
		firefox --new-tab http://websdr.ewi.utwente.nl:8901/

	elif [  "$ans" = "OpenWebRX, OE4XLC, Allhau, Austria" ]; then
		firefox --new-tab http://www.websdr.at:8073/

	elif [  "$ans" = "OpenWebRX, ZL/KF6VO, New Zealand" ]; then
		firefox --new-tab http://kiwisdr.jks.com:8073/

	elif [  "$ans" = "OpenWebRX, SK3W, Sweden" ]; then
		firefox --new-tab http://kiwisdr.sk3w.se:8073/

	elif [  "$ans" = "OpenWebRX, VE7AB, Victoria, BC (CA)" ]; then
		firefox --new-tab http://kiwisdr.ece.uvic.ca:8073/

	elif [  "$ans" = "OpenWebRX, KD4HSO, Overland Park, Kansas (USA)" ]; then
		firefox --new-tab http://64.136.200.36:8073/

	elif [  "$ans" = "WebSDR, K2SDR, New Jersey (USA)" ]; then
		firefox --new-tab http://100.1.108.103:8902/

	elif [  "$ans" = "WebSDR, G4FPH, Stafford (UK)" ]; then
		firefox --new-tab http://www.160m.net/

	elif [  "$ans" = "WebSDR, N4DKD, Alabama (USA)" ]; then
		firefox --new-tab http://n4dkd.asuscomm.com:8901/

	elif [  "$ans" = "WebSDR, SP3PGX, Zielona Gora, Poland" ]; then
		firefox --new-tab http://websdr.sp3pgx.uz.zgora.pl:8901/

	elif [  "$ans" = "WebSDR, Peterborough (UK)" ]; then
		firefox --new-tab http://cambs-sdr.no-ip.org:8901/

	elif [  "$ans" = "WebSDR, DG0KF, Greifswald, (DE)" ]; then
		firefox --new-tab http://db0ovp.de:8901/

	elif [  "$ans" = "WebSDR, Silec, Poland" ]; then
		firefox --new-tab http://websdr.printf.cc:8901/

	elif [  "$ans" = "WebSDR, W3ISZ, California (USA)" ]; then
		firefox --new-tab http://w3isz.ham-radio-op.net:8073/

	fi

