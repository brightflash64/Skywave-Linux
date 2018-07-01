#! /bin/sh

# sdr-updater for Skywave Linux, version 1.0
# Copyright (c) 2017 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# SDR Updater is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Encoding=UTF-8

aptupgrade(){
apt update
apt -y upgrade
echo "\n\nFinished installing software from the repositories."
}

getsdrplay(){
#get the sdrplay linux api installer manually
#from http://sdrplay.com/linuxdl.php
#then enable and run it:
#echo "\n\n...SDRplay MiricsAPI..."
#echo "\nGet it manually from http://sdrplay.com/"
#echo "\nRobots are people too."
#cd ~
#chmod 755 SDRplay_RSP_API-Linux-2.10.2.run
#./SDRplay_RSP_API-Linux-2.10.2.run
#rm -f SDRplay_RSP_API-Linux-2.10.2.run

#open source sdrplay driver from f4exb
#cd ~
#git clone https://github.com/f4exb/libmirisdr-4
#mkdir libmirisdr-4/build
#cd libmirisdr-4/build
#cmake ../
#make
#make install
#ldconfig
#cd ~
#rm -rf libmirisdr-4

#SDRplay support in OpenWebRX
echo "\n\n...openwebrx dependencies for sdrplay (SDRPlayPorts)"
cd ~
git clone https://github.com/krippendorf/SDRPlayPorts
mkdir SDRPlayPorts/build
cd SDRPlayPorts/build
cmake ..
make
make install
ldconfig
cd ~
rm -rf SDRPlayPorts
}

getrtlsdr(){
#install rtl-sdr drivers
echo "\n\n...rtl-sdr firmware..."
echo "\n\n...rtl-sdr firmware is now updated from the repositories."
#cd ~
#git clone https://git.osmocom.org/rtl-sdr
#git clone https://github.com/steve-m/librtlsdr
#git clone https://github.com/mutability/rtl-sdr
#git clone https://github.com/thaolia/librtlsdr-thaolia
#mv librtlsdr-thaolia rtl-sdr
#git clone https://github.com/AB9IL/rtl-sdr
#mkdir rtl-sdr/build
#cd rtl-sdr/build
#cmake ../ -DINSTALL_UDEV_RULES=ON
#make
#make install
#ldconfig
#rm -rf rtl-sdr
}

getsoapy(){
#get the SoapyAudio support module
echo "\n\n...soapy audio"
echo "\n\n...Soapy SDR drivers are now updated from the repositories."
#cd ~
#git clone https://github.com/pothosware/SoapyAudio
#mkdir SoapyAudio/build
#cd SoapyAudio/build
#cmake ..
#make
#make install
#ldconfig
#cd ~
#rm -rf SoapyAudio

#get SoapyPlutoSDR support module
echo "\n\n...SoapyPlutoSDR"
echo "\n\n...Soapy SDR drivers are now updated from the repositories."
#cd ~
#git clone https://github.com/jocover/SoapyPlutoSDR
#mkdir SoapyPlutoSDR/build
#cd SoapyPlutoSDR/build
#cmake ..
#make
#sudo make install
#ldconfig

#get the SoapySDRPlay support module for CubicSDR
echo "\n\n...SoapySDRPlay..."
echo "\n\n...Soapy SDR drivers are now updated from the repositories."
#cd ~
#git clone https://github.com/pothosware/SoapySDRPlay
#mkdir SoapySDRPlay/build
#cd SoapySDRPlay/build
#cmake .. -DCMAKE_BUILD_TYPE=Release
#make
#make install
#ldconfig
#cd ~
#rm -rf SoapySDRPlay
}

getqtradio(){
#get qtradio
echo "\n\n...QtRadio..."
cd ~
git clone https://github.com/alexlee188/ghpsdr3-alex
cd ghpsdr3-alex
sh cleanup.sh
git checkout master
autoreconf -i
./configure
make -j4 all
make install
cd ~
rm -rf ghpsdr3-alex

#Create a better launcher
echo '[Desktop Entry]
Type=Application
Name=QtRadio
Name[xx]=QtRadio
Generic Name=SDR GUI
Exec=QtRadio
Icon=QtRadio
Terminal=False
Categories=;HamRadio;' > /usr/local/share/applications/QtRadio.desktop
}

getopenwebrx(){
echo "\n\n...csdr dsp library..."
# get the csdr dsp library
cd ~
git clone https://github.com/simonyiszk/csdr
cd csdr
make
make install
ldconfig
cd ~
rm -rf csdr
echo "\n\n...Openwebrx..."
# get openwebrx
cd ~
git clone https://github.com/simonyiszk/openwebrx
# nothing to make
# move the files
cp -ar ~/openwebrx /usr/local/sbin/openwebrx
}

getcubicsdr(){
#install CubicSDR and dependencies
echo "\n\n...CubicSDR AppImage..."
cd ~
wget "https://github.com/cjcliffe/CubicSDR/releases/download/0.2.4/CubicSDR-0.2.4-x86_64.AppImage"
chmod +x CubicSDR-0.2.4-x86_64.AppImage
mv ~/CubicSDR-0.2.4-x86_64.AppImage /usr/local/sbin/CubicSDR/CubicSDR.AppImage

#remake the launcher
echo '[Desktop Entry]
Name=CubicSDR
GenericName=CubicSDR
Comment=RTL-SDR - Software Defined Radio
Exec=/usr/local/sbin/CubicSDR/CubicSDR.AppImage
Icon=/usr/share/pixmaps/CubicSDR.ico
Terminal=false
Type=Application
Categories=HamRadio;' > /usr/local/share/applications/cubicsdr.desktop
}

getremotesdrclient(){
echo "\n\n...RemoteSdrClient-NS..."
#get RemoteSdrClient-NS (for RFSpace hardware)
cd ~
git clone https://github.com/csete/remotesdrclient-ns
cd remotesdrclient-ns
make
#manually copy the binary to /usr/local/bin
cp ~/remotesdrclient-ns/remotesdrclient-ns /usr/local/bin/remotesdrclient-ns
#manually copy the icon to /usr/share/pixmaps
cp ~/remotesdrclient-ns/RemoteSdrClient.png /usr/share/pixmaps/RemoteSdrClient.png
#create the launcher
echo '[Desktop Entry]
Name=RemoteSdrClient
GenericName=RemoteSdrClient
Comment=Remote Client for RFSpace SDRs
Exec=/usr/local/bin/remotesdrclient-ns
Icon=RemoteSdrClient.png
Terminal=false
Type=Application
Categories=Network;HamRadio;' > /usr/share/applications/remotesdrclient.desktop
}

getgqrx(){
echo "\n\n...Gqrx AppImage..."
#install Gqrx and dependencies
cd ~
wget "https://github.com/csete/gqrx/releases/download/v2.11.2/Gqrx-2.11.2-x86_64.AppImage"
chmod +x Gqrx-2.11.2-x86_64.AppImage
mv ~/Gqrx-2.11.2-x86_64.AppImage /usr/local/sbin/gqrx/gqrx.AppImage

#create the launcher
echo '[Desktop Entry]
Type=Application
Name=Gqrx
GenericName=Software Defined Radio
Comment=Software defined radio receiver implemented using GNU Radio and the Qt GUI toolkit
# FIXME add comments in other languages
GenericName[ru]=Программно-определённое радио
Comment[ru]=Приемник для программно-определенного радио (SDR) использующий GNU Radio и библиотеку Qt.
GenericName[nl]=Software Defined Radio
Comment[nl]=Software defined radio ontvanger geïmplementeerd met GNU Radio en de Qt GUI toolkit
Comment[de]=Software defined Radio auf Basis von GNU Radio und dem Qt GUI Toolkit
Exec=/usr/local/sbin/gqrx/gqrx.AppImage
Terminal=false
Icon=gqrx.png
Categories=Network;HamRadio;
Keywords=SDR;Radio;HAM;' > /usr/share/applications/gqrx.desktop
}

rtlsdrairband(){
#get rtlsdr-airband
cd ~
git clone https://github.com/szpajder/RTLSDR-Airband
cd RTLSDR-Airband
PLATFORM=x86 NFM=1 make
make install

#get acarsdec
cd ~
git clone https://github.com/AB9IL/acarsdec
cd acarsdec
autoreconf
./configure
make
make acarsserv
cp acarsdec /usr/local/sbin/acarsdec
cp acarsserv /usr/local/sbin/acarsdec
cd ~

#get dumpvdl2
git clone https://github.com/szpajder/dumpvdl2
cd dumpvdl2
make
cp ~/dumpvdl2/dumpvdl2 /usr/local/bin/dumpvdl2
cd ~
rm -rf acarsdec
rm -rf dumpvdl2
}

getdump1090(){
echo "\n\n...dump1090 for rtl-sdr devices..."
cd ~
#git clone https://github.com/mutability/dump1090
git clone https://github.com/MalcolmRobb/dump1090
cd dump1090
make
cp -ar public_html /usr/local/sbin/dump1090/public_html
cp -ar testfiles /usr/local/sbin/dump1090/testfiles
cp -ar tools /usr/local/sbin/dump1090/tools
cp dump1090 /usr/local/sbin/dump1090/dump1090
cp view1090 /usr/local/sbin/dump1090/view1090
cp README.md /usr/local/sbin/dump1090/README.md
cd ~
rm -rf dump1090
echo "\n\n...completed update for dump1090 for rtl-sdr devices..."
}

getr820tweak(){
echo "\n\n...getting r820tweak..."
cd ~
git clone https://github.com/gat3way/r820tweak
cd r820tweak
make
make install
cd ~
rm -rf r820tweak
ldconfig
}

getsdrtrunk(){
#sdrtrunk
echo "\n\n...SDRTrunk..."
cd ~
wget "https://github.com/DSheirer/sdrtrunk/releases/download/v0.3.3-beta.3/sdr-trunk-all-0.3.3-beta.3.jar"
mv sdr-trunk-all-0.3.3-beta.3.jar /usr/local/sbin/sdrtrunk.jar
}

getrtaudio(){
#get rtaudio
echo "\n\n...rtaudio"
cd ~
git clone https://github.com/thestk/rtaudio
mkdir rtaudio/build
cd rtaudio/build
cmake .. -DAUDIO_LINUX_PULSE=ON
cd rtaudio
./autogen.sh --with-pulse
make
make install
ldconfig
cd ~
rm -rf rtaudio
}

getcrypto(){
#lantern
echo "\n\n...getting Lantern..."
cd ~
wget "https://s3.amazonaws.com/lantern/lantern-installer-beta-64-bit.deb"
dpkg -i lantern-installer-beta-64-bit.deb

#replace the launcher
echo '[Desktop Entry]
Type=Application
Name=Lantern
Exec=sh -c "lantern -addr 127.0.0.1:8118"
Icon=lantern
Comment=Censorship circumvention (proxy / vpn) application for unblocked web browsing.
Categories=Network;Internet;Networking;Privacy;Proxy;VPN;' > /usr/share/applications/lantern.desktop

#update cjdns
echo "\n\n...updating cjdns..."
sh -c "/etc/init.d/cjdns update"

# get psiphon
# optionally, use this dev's repo: https://github.com/thispc/psiphon
git clone https://github.com/gilcu3/psiphon
cd psiphon

#get openssh-portable for psiphon
#optionally, use version 5.9p1
cd ~
git clone https://github.com/openssh/openssh-portable
cd openssh-portable
autoreconf
./configure
make
# move up one level then copy the ssh binary to the Psiphon directory.
cd ..
rm ssh
cp openssh-portable/ssh .
}

ans=$(zenity  --list --height 470 --width 420 --text "SDR Software Updater" --radiolist  --column "Pick" --column "Action" \
TRUE "Upgrade Base System and Drivers with Apt" FALSE "Update QtRadio" FALSE "Update CubicSDR" FALSE "Update Gqrx" \
FALSE "Update RemoteSdrClient" FALSE "Update OpenwebRX" FALSE "Update R820tweak" FALSE "Update SoapySDR Drivers" \
FALSE "Update Dump1090" FALSE "Update SDRPlay Drivers" FALSE "Update RTL-SDR"  FALSE "Update RTLSDR-Airband" \
FALSE "Update SDRTrunk" FALSE "Update Rtaudio" FALSE "Update Mesh Networking & Crypto");

	if [  "$ans" = "Upgrade Base System and Drivers with Apt" ]; then
		aptupgrade

	elif [  "$ans" = "Update QtRadio" ]; then
		getqtradio

	elif [  "$ans" = "Update CubicSDR" ]; then
		getcubicsdr

	elif [  "$ans" = "Update Gqrx" ]; then
		getgqrx

	elif [  "$ans" = "Update RemoteSdrClient" ]; then
		getremotesdrclient

	elif [  "$ans" = "Update Dump1090" ]; then
		getdump1090

	elif [  "$ans" = "Update OpenwebRX" ]; then
		getopenwebrx

	elif [  "$ans" = "Update R820tweak" ]; then
		getr820tweak

	elif [  "$ans" = "Update SoapySDR Drivers" ]; then
		getsoapy

	elif [  "$ans" = "Update SDRPlay Drivers" ]; then
		getsdrplay

	elif [  "$ans" = "Update RTL-SDR Drivers" ]; then
		getrtlsdr

	elif [  "$ans" = "Update RTLSDR-Airband" ]; then
		rtlsdrairband

	elif [  "$ans" = "Update SDRTrunk" ]; then
		getsdrtrunk

	elif [  "$ans" = "Update Rtaudio" ]; then
		getrtaudio

	elif [  "$ans" = "Update Mesh Networking & Crypto" ]; then
		getcrypto

	fi

echo "\n\nScript Execution Completed!"
read -p "\n\nPress any key to continue..." 
