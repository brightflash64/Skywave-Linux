#!/bin/sh
Encoding=UTF-8

ans=$(zenity  --list --height 420 --width 300 --text "WebSDR and OpenwebRX Servers" --radiolist  --column "Pick" --column "Action" TRUE "WebSDR - Online List" FALSE "OpenWebRX - Online List" FALSE "University of Twente (NL)"  FALSE "ZL/KF6VO, New Zealand" FALSE "SK3W, Sweden" FALSE "VE7AB, Victoria, BC, Canada" FALSE "K2SDR, New Jersey (USA)"  FALSE "G4FPH, Stafford (UK)" FALSE "N4DKD, Alabama (USA)" FALSE "SP3PGX, Zielona Gora, Poland" FALSE "WebSDR, Peterborough (UK)" FALSE "WebSDR, Silec, Poland" FALSE "PA3HEA, Zoetermeer (NL)" FALSE "W3ISZ, California (USA)");

	if [  "$ans" = "WebSDR - Online List" ]; then
		firefox --new-tab http://websdr.org/

	elif [  "$ans" = "OpenWebRX - Online List" ]; then
		firefox --new-tab http://sdr.hu/

	elif [  "$ans" = "University of Twente (NL)" ]; then
		firefox --new-tab http://websdr.ewi.utwente.nl:8901/

	elif [  "$ans" = "ZL/KF6VO, New Zealand" ]; then
		firefox --new-tab http://kiwisdr.jks.com:8073/

	elif [  "$ans" = "SK3W, Sweden" ]; then
		firefox --new-tab http://kiwisdr.sk3w.se:8073/

	elif [  "$ans" = "VE7AB, Victoria, BC, Canada" ]; then
		firefox --new-tab http://kiwisdr.ece.uvic.ca:8073/

	elif [  "$ans" = "K2SDR, New Jersey (USA)" ]; then
		firefox --new-tab http://100.1.108.103:8902/

	elif [  "$ans" = "G4FPH, Stafford (UK)" ]; then
		firefox --new-tab http://www.160m.net/

	elif [  "$ans" = "N4DKD, Alabama (USA)" ]; then
		firefox --new-tab http://n4dkd.asuscomm.com:8901/

	elif [  "$ans" = "SP3PGX, Zielona Gora, Poland" ]; then
		firefox --new-tab http://websdr.sp3pgx.uz.zgora.pl:8901/

	elif [  "$ans" = "WebSDR, Peterborough (UK)" ]; then
		firefox --new-tab http://cambs-sdr.no-ip.org:8901/

	elif [  "$ans" = "WebSDR, Silec, Poland" ]; then
		firefox --new-tab http://websdr.printf.cc:8901/

	elif [  "$ans" = "PA3HEA, Zoetermeer (NL)" ]; then
		firefox --new-tab http://bwa-lb.dyndns.org:8073/

	elif [  "$ans" = "W3ISZ, California (USA)" ]; then
		firefox --new-tab http://w3isz.ham-radio-op.net:8073/

	fi

