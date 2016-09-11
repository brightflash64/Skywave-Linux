#! /bin/sh

#System setup script for Skywave Linux v2.0
#Use on Ubuntu / Mint / Debian
#Run this script as root!

#blacklist the rtl28xxu kernel driver
echo "blacklist dvb_usb_rtl28xxu
blacklist e4000
blacklist rtl2832" >> /etc/modprobe.d/rtl-sdr-blacklist.conf

#set performance configuration in sysctl.conf
echo "
############
net.core.somaxconn = 1000
net.core.netdev_max_backlog = 5000
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_wmem = 4096 12582912 16777216
net.ipv4.tcp_rmem = 4096 12582912 16777216
net.ipv4.tcp_max_syn_backlog = 8096
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10240 65535
# Set swappiness
vm.swappiness=10
# Improve cache management
vm.vfs_cache_pressure=50" >> /etc/sysctl.conf

#increase Ubuntu privacy, recuce resource load, remove conflicting packages
apt-get purge --auto-remove speech-dispatcher modemmanager cheese libreoffice* rhythmbox* shotwell unity-lens-shopping webbrowser-app
systemctl disable snapd.refresh.service
apt-get -y autoremove
apt-get clean

echo "\nSetting up repositories..."
#firefox, gqrx, fldigi, kodi
add-apt-repository ppa:mozillateam/firefox-next
add-apt-repository ppa:bladerf/bladerf-snapshots
apt-add-repository ppa:dansmith/chirp-snapshots
add-apt-repository ppa:ettusresearch/uhd
add-apt-repository ppa:gpredict-team/daily
add-apt-repository ppa:gqrx/gqrx-sdr
add-apt-repository ppa:kamalmostafa/fldigi
add-apt-repository ppa:team-xbmc/unstable
add-apt-repository ppa:myriadrf/drivers
add-apt-repository ppa:myriadrf/gnuradio

#Ubuntu
add-apt-repository multiverse
add-apt-repository universe
add-apt-repository xenial-backports
add-apt-repository xenial-proposed
add-apt-repository xenial-updates

# get everything that we want from the repositories
echo "\nGetting packages from the repositories..."
apt-get update
apt-get upgrade
apt-get -y install $(grep -vE "^\s*#" newsoftware  | tr "\n" " ")
echo "\nFinished installing software from the repositories."
echo "\nStarting installation from source code.  Please stand by..."

#cjdns
echo "\n...CJDNS..."
cd ~
cp ~/files/scripts/cjdns.sh /etc/init.d/cjdns
chmod +x /etc/init.d/cjdns
/etc/init.d/cjdns install
#set link for nodejs
ln -s /usr/bin/nodejs /usr/bin/node

#lantern
wget "https://s3.amazonaws.com/lantern/lantern-installer-beta-64-bit.deb"
dpkg -i lantern-installer-beta-64-bit.deb

#get qtradio
echo "\n...QtRadio..."
cd ~
git clone https://github.com/alexlee188/ghpsdr3-alex
cd ghpsdr3-alex
sh cleanup.sh
git checkout master
autoreconf -i
./configure
make -j4 all
make install

#install rtl-sdr drivers
echo "\n...rtl-sdr firmware..."
cd ~
git clone https://git.osmocom.org/rtl-sdr
mkdir rtl-sdr/build
cd rtl-sdr/build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig

#install rx_tools
echo "\n...rx_tools..."
cd ~
git clone https://github.com/rxseger/rx_tools
mkdir rx_tools/build
cd rx_tools/build
cmake ..
make
make install
ldconfig

#install rtl_hpsdr
#build librtlsdr, but only keep rtl_hpsdr
echo "\n...rtl_hpsdr..."
cd ~
git clone https://github.com/n1gp/librtlsdr
mkdir librtlsdr/build
cd librtlsdr/build
cmake ..
make
cp ~/librtlsdr/build/src/rtl_hpsdr /usr/local/bin/rtl_hpsdr

#install airspy support
echo "\n...Airspy Host..."
cd ~
git clone https://github.com/airspy/host/
mkdir host/build
cd host/build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig

#get the sdrplay linux api installer manually
#from http://sdrplay.com/linuxdl.php
#then enable and run it:
echo "\n...SDRplay MiricsAPI..."
cd ~
chmod 755 SDRplay_RSP_MiricsAPI-Linux-1.95.3.run
./SDRplay_RSP_MiricsAPI-Linux-1.95.3.run

#get sdrplay support from osmocom
echo "\n...gr-osmosdr..."
cd ~
#use the hb9fxq fork with better sdrplay support
git clone https://github.com/krippendorf/gr-osmosdr-fork-sdrplay
mkdir gr-osmosdr-fork-sdrplay/build
cd gr-osmosdr-fork-sdrplay/build
cmake -DENABLE_NONFREE=TRUE ../
make
make install
ldconfig

#install hackrf support
echo "\n...hackrf..."
cd ~
git clone https://github.com/mossmann/hackrf
mkdir hackrf/host/build
cd hackrf/host/build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig

#install OpenwebRX and dependencies
echo "\nGetting the csdr dsp library..."
# get the csdr dsp library
cd ~
git clone https://github.com/simonyiszk/csdr
cd csdr
make
make install
ldconfig
cd ~
rm -rf csdr
echo "\n\n\nGetting Openwebrx..."
# get openwebrx
cd ~
git clone https://github.com/simonyiszk/openwebrx
# nothing to make
# move the files
mv -ar ~/openwebrx /usr/local/sbin/openwebrx

#install cudaSDR
echo "\n...cudaSDR..."
cd ~
git clone https://github.com/n1gp/cudaSDR
cd cudaSDR/Source
qmake cudaSDR.pro
make
cp ~/cudaSDR/Source/bin/cudaSDR /usr/local/bin/cudaSDR
cp ~/cudaSDR/Source/bin/settings.ini /usr/local/bin/settings.ini

#install CubicSDR and dependencies
#get liquid-dsp
echo "\n...liquid-dsp..."
cd ~
git clone https://github.com/jgaeddert/liquid-dsp
cd liquid-dsp
./bootstrap.sh
./configure
make
make install
ldconfig

#get SoapySDR
echo "\n...SoapySDR..."
cd ~
git clone https://github.com/pothosware/SoapySDR
mkdir SoapySDR/build
cd SoapySDR/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
make install
ldconfig

#get the SoapyRTLSDR support module
echo "\n...SoapyRTLSDR..."
cd ~
git clone https://github.com/pothosware/SoapyRTLSDR
mkdir SoapyRTLSDR/build
cd SoapyRTLSDR/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
make install
ldconfig

#get the SoapySDRPlay support module
echo "\n...SoapySDRPlay..."
cd ~
git clone https://github.com/pothosware/SoapySDRPlay
mkdir SoapySDRPlay/build
cd SoapySDRPlay/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
make install
ldconfig

#get CubicSDR
echo "\n...CubicSDR..."
cd ~
git clone https://github.com/cjcliffe/CubicSDR
mkdir CubicSDR/build
cd CubicSDR/build
cmake ../
make

#move it to /opt
mkdir /opt/CubicSDR
cp -ar ~/CubicSDR/build/x64/* /opt/CubicSDR

#create menu entry via .desktop file
echo '[Desktop Entry]
Name=CubicSDR
GenericName=CubicSDR
Comment=Software Defined Radio
Exec=/opt/CubicSDR/CubicSDR
Icon=/opt/CubicSDR/CubicSDR.ico
Terminal=false
Type=Application
Categories=Network;HamRadio;' > /usr/share/applications/cubicsdr.desktop

#get dump1090 for rtl-sdr devices
echo "\n...dump1090 for rtl-sdr devices..."
cd ~
#git clone https://github.com/mutability/dump1090
git clone https://github.com/MalcolmRobb/dump1090
cd dump1090
make
mkdir /usr/local/sbin/dump1090
cp -ar ~/dump1090/public_html /usr/local/sbin/dump1090/public_html
cp ~/dump1090/testfiles /usr/local/sbin/dump1090/testfiles
cp ~/dump1090/tools /usr/local/sbin/dump1090/tools
cp ~/dump1090/dump1090 /usr/local/sbin/dump1090/dump1090
cp ~/dump1090/view1090 /usr/local/sbin/dump1090/view1090
cp ~/dump1090/LICENSE /usr/local/sbin/dump1090/LICENSE
cp ~/dump1090/README.md /usr/local/sbin/dump1090/README.md
cp ~/dump1090/README-dump1090.md /usr/local/sbin/dump1090/README-dump1090.md
cp ~/dump1090/README-json.md /usr/local/sbin/dump1090/README-json.md

#get dump1090 with advanced device support
echo "\n...dump1090 for advanced devices..."
cd ~
git clone https://github.com/itemir/dump1090_sdrplus
cd dump1090_sdrplus
make
mkdir /usr/local/sbin/dump1090_sdrplus
cp -ar ~/dump1090_sdrplus/testfiles /usr/local/sbin/dump1090_sdrplus/testfiles
cp -ar ~/dump1090_sdrplus/tools /usr/local/sbin/dump1090_sdrplus/tools
cp ~/dump1090_sdrplus/dump1090 /usr/local/sbin/dump1090_sdrplus/dump1090
cp ~/dump1090_sdrplus/gmap.html /usr/local/sbin/dump1090_sdrplus/gmap.html
cp ~/dump1090_sdrplus/README.md /usr/local/sbin/dump1090_sdrplus/README.md

#create dump1090 menu entry via .desktop file
echo '[Desktop Entry]
Name=Dump1090
GenericName=Dump1090
Comment=Mode S SDR (software defined radio).
Exec=/usr/local/sbin/dump1090.sh
Icon=/usr/share/pixmaps/dump1090.png
Terminal=false
Type=Application
Categories=Network;HamRadio;ADSB;Radio;' > /usr/share/applications/dump1090.desktop

#get wxtoimg
echo "\n...WxtoImg..."
cd ~
wget "http://www.wxtoimg.com/beta/wxtoimg-amd64-2.11.2-beta.deb"
dpkg -i wxtoimg-amd64-2.11.2-beta.deb

#install readsea
echo "\n...Redsea..."
cd ~
git clone https://github.com/windytan/redsea
cd redsea
autoreconf --install
./configure
make
make install

#create menu entry via .desktop file
echo '[Desktop Entry]
Name=Redsea RDS Decoder
GenericName=Redsea RDS Decoder
Comment=Redsea FM Radio Data Decoder
Exec=gnome-terminal -e "/usr/local/sbin/redsea-controller.sh"
Type=Application
Icon=remmina
Terminal=false
NoDisplay=false
StartupNotify=false
Terminal=0
TerminalOptions=
Categories=HamRadio;Audio;Video' > /usr/share/applications/redsea-controller.desktop

#sdrtrunk
echo "\n...SDRTrunk..."
cd ~
wget "https://github.com/DSheirer/sdrtrunk/releases/download/v0.2.0/sdrtrunk_0.2.0.tar.gz"
tar -zxvf sdrtrunk_0.2.0.tar.gz
cp ~/sdrtrunk/config/*.rules /etc/udev/rules.d/

#move it to /opt
cp -ar ~/sdrtrunk /opt/sdrtrunk

#create launcher
echo '[Desktop Entry]
Comment=Monitor trunked radio systems via SDR hardware.
Name=SDRTrunk
GenericName=SDRTrunk
Icon=/usr/share/pixmaps/sdrtrunk.png
Exec=/usr/local/sbin/sdrtrunk-controller.sh
NoDisplay=false
StartupNotify=false
Terminal=0
TerminalOptions=
Type=Application
Categories=Ham;Hamradio;SDR;Radio;' > /usr/share/applications/sdrtrunk.desktop

#get WSJT-X
echo "\n...WSJT-X..."
cd ~
wget "http://physics.princeton.edu/pulsar/k1jt/wsjtx_1.6.0_amd64.deb"
dpkg -i wsjtx_1.6.0_amd64.deb

#get WSPR-X
echo "\n...WSPR-X..."
cd ~
svn co svn://svn.code.sf.net/p/wsjt/wsjt/branches/wsprx
cd ~/wsprx/lib
make -f Makefile.linux
cd ..
qmake
make
cp ~/wsprx_install/WSPRcode /usr/local/bin/WSPRcode
cp ~/wsprx_install/wsprd /usr/local/bin/wsprd
cp ~/wsprx_install/wsprx /usr/local/bin/wsprx

#################################
cd ~
echo "\nFinished installing software from source code!"
echo "\nCleaning up apt..."
apt-get -y autoremove
apt-get clean

echo "\nCopying files and scripts..."
#create directories
mkdir /etc/skel/cjdns
mkdir /usr/local/sbin/cjdns

#move certain files into the new system
cp ~/files/apt/10periodic /etc/apt/apt.conf.d/10periodic
cp ~/files/rhythmbox/iradio-initial.xspf /usr/share/rhythmbox/plugins/iradio/iradio-initial.xspf
cp ~/files/alsa/asound.state /var/lib/alsa/asound.state
cp ~/files/pulse/daemon.conf /etc/pulse/daemon.conf
cp ~/files/pulse/default.pa /etc/pulse/default.pa
cp ~/files/pulse/system.pa /etc/pulse/system.pa
cp ~/files/networking/resolv.conf /run/resolvconf/resolv.conf
cp ~/files/networking/resolvconf /etc/network/if-up.d/resolvconf
cp ~/files/etc/asound.conf /etc/asound.conf
cp ~/files/etc/issue /etc/issue
cp ~/files/etc/issue.net /etc/issue.net
cp ~/files/etc/legal /etc/legal
cp ~/files/etc/lsb-release /etc/lsb-release
cp ~/files/etc/os-release /etc/os-release
cp ~/files/etc/rtl-sdr-blacklist.conf /etc/modprobe.d/rtl-sdr-blacklist.conf
cp ~/files/gedit/org.gnome.gedit.gschema.xml /usr/share/glib-2.0/schemas/org.gnome.gedit.gschema.xml
cp ~/files/scripts/cjdns-controller.sh /usr/local/sbin/cjdns-controller.sh
cp ~/files/scripts/dump1090.sh /usr/local/sbin/dump1090.sh
cp ~/files/scripts/redsea-controller.sh /usr/local/sbin/redsea-controller.sh
cp ~/files/scripts/rtl-hpsdr-controller.sh /usr/local/sbin/rtl-hpsdr-controller.sh
cp ~/files/scripts/rtlsdr-controller.sh /usr/local/sbin/rtlsdr-controller.sh
cp ~/files/scripts/softrock-controller.sh /usr/local/sbin/softrock-controller.sh
cp ~/files/scripts/sdrtrunk-controller.sh /usr/local/sbin/sdrtrunk-controller.sh
cp ~/files/scripts/websdr-list.sh /usr/local/sbin/websdr-list.sh
cp ~/files/cjdns/cjdns_peers_ipv4 /etc/skel/cjdns/cjdns_peers_ipv4
cp ~/files/cjdns/cjdns_peers_ipv6 /etc/skel/cjdns/cjdns_peers_ipv6
cp ~/files/cjdns/cjdns_peers_ipv4_link /usr/local/sbin/cjdns/cjdns_peers_ipv4
cp ~/files/cjdns/cjdns_peers_ipv6_link /usr/local/sbin/cjdns/cjdns_peers_ipv6
cp ~/files/apps/cjdns-controller.desktop /usr/share/applications/cjdns-controller.desktop
cp ~/files/apps/bitmask.desktop /usr/share/applications/bitmask.desktop
cp ~/files/apps/cubicsdr.desktop /usr/share/applications/cubicsdr.desktop
cp ~/files/apps/cudasdr.desktop /usr/share/applications/cudasdr.desktop
cp ~/files/apps/lantern.desktop /usr/share/applications/lantern.desktop
cp ~/files/apps/nautilus-root.desktop /usr/share/applications/nautilus-root.desktop
cp ~/files/apps/openwebrx.desktop /usr/share/applications/openwebrx.desktop
cp ~/files/apps/openwebrx-dsamp.desktop /usr/share/applications/openwebrx-dsamp.desktop
cp ~/files/apps/openwebrx-sdrplay.desktop /usr/share/applications/openwebrx-sdrplay.desktop
cp ~/files/apps/openwebrx-soundcard.desktop /usr/share/applications/openwebrx-soundcard.desktop
cp ~/files/apps/rtl-hpsdr-controller.desktop /usr/share/applications/rtl-hpsdr-controller.desktop
cp ~/files/apps/rtlsdr-controller.desktop /usr/share/applications/rtl-hpsdr-controller.desktop
cp ~/files/apps/skywavelinux.desktop /usr/share/applications/skywavelinux.desktop
cp ~/files/apps/softrock-controller.desktop /usr/share/applications/softrock-controller.desktop
cp ~/files/apps/ubiquity.desktop /usr/share/applications/ubiquity.desktop
cp ~/files/apps/wsjtx.desktop /usr/share/applications/wsjtx.desktop
cp ~/files/apps/wsprx.desktop /usr/share/applications/wsprx.desktop
cp ~/files/apps/wxtoimg.desktop /usr/share/applications/wxtoimg.desktop
cp ~/files/icons/Cjdns_logo.png /usr/share/pixmaps/Cjdns_logo.png
cp ~/files/icons/CQ.png /usr/share/pixmaps/CQ.png
cp ~/files/icons/CudaSDR.png /usr/share/pixmaps/CudaSDR.png
cp ~/files/icons/dump1090.png /usr/share/pixmaps/dump1090.png
cp ~/files/icons/sdrtrunk.png /usr/share/pixmaps/sdrtrunk.png
cp ~/files/icons/wsjtx_icon.png /usr/share/pixmaps/wsjtx_icon.png
cp ~/files/icons/wsprx_icon.png /usr/share/pixmaps/wsprx_icon.png
cp ~/files/icons/wxtoimg.png /usr/share/pixmaps/wxtoimg.png
cp -ar ~/files/opt/html /opt/html
cp -ar ~/files/openwebrx /usr/local/sbin/openwebrx
cp -ar ~/files/etc/skel /etc/skel

#run volk_profile to optimise for certain sdr apps
echo "\nRunning volk_profile to optimise certain SDR applications"

echo "\nAll tasks finished!"
