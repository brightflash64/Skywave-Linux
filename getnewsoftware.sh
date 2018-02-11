#! /bin/sh

#System setup script for Skywave Linux v3.1
#Use on Ubuntu / Mint / Debian
#Run this script as root within the chroot!

#increase Ubuntu privacy, reduce resource load, remove conflicting packages
#remove packages that came from unity, as we now use the mate desktop 
apt purge --auto-remove speech-dispatcher modemmanager cheese* libreoffice* rhythmbox* shotwell unity-lens-shopping webbrowser-app deja-dup indicator-messages nautilus* plymouth-theme-ubuntu-text snap-confine* ubuntu-core-launcher* ubiquity-ubuntu-artwork whoopsie zeitgeist zeitgeist-core unity-control-center unity-control-center-faces

#remove some MATE and Gnome apps
apt purge --auto-remove aisleriot cheese file-roller evince gedit gdm3 gnome-* mate-utils-common xul-ext-ubufox

apt clean

echo "\nSetting up repositories..."
#firefox, gqrx, fldigi, kodi, pulseefeects, etc
add-apt-repository -y ppa:mozillateam/firefox-next
add-apt-repository -y ppa:bladerf/bladerf
add-apt-repository -y ppa:dansmith/chirp-snapshots
add-apt-repository -y ppa:ettusresearch/uhd
add-apt-repository -y ppa:llb/freesrp
add-apt-repository -y ppa:gpredict-team/daily
add-apt-repository -y ppa:gqrx/gqrx-sdr
add-apt-repository -y ppa:kamalmostafa/fldigi
add-apt-repository -y ppa:nm-l2tp/network-manager-l2tp
add-apt-repository -y ppa:noobslab/icons
add-apt-repository -y ppa:noobslab/themes
add-apt-repository -y ppa:pothosware/framework
add-apt-repository -y ppa:pothosware/support
add-apt-repository -y ppa:team-xbmc/unstable
add-apt-repository -y ppa:myriadrf/drivers
add-apt-repository -y ppa:myriadrf/gnuradio
add-apt-repository -y ppa:yunnxx/gnome3

#Ubuntu
add-apt-repository -y multiverse
add-apt-repository -y universe
add-apt-repository -y xenial-backports
add-apt-repository -y xenial-proposed
add-apt-repository -y xenial-updates
add-apt-repository -y ppa:ubuntu-x-swat/updates
add-apt-repository -y ppa:xorg-edgers/ppa

#node.js
wget -O- https://deb.nodesource.com/setup_8.x | sudo -E bash -

# get bitmask
add-apt-repository "deb http://deb.bitmask.net/debian xenial main"
wget -O- https://dl.bitmask.net/apt.key | apt-key add -
apt update
apt install bitmask leap-archive-keyring

#python tools for psiphon
pip install wget pexpect cryptography

# replace mate-screenshot with a symlink to gnome-screenshot
ln -s gnome-screenshot mate-screenshot

# get everything that we want from the repositories
echo "\nGetting packages from the repositories..."
apt update
apt -y upgrade
apt -y install $(grep -vE "^\s*#" newsoftware  | tr "\n" " ")
echo "\nFinished installing software from the repositories."
echo "\nStarting installation from source code.  Please stand by..."

#install rtl-sdr drivers
echo "\n...rtl-sdr firmware..."
cd ~
#git clone https://git.osmocom.org/rtl-sdr
#git clone https://github.com/steve-m/librtlsdr
#git clone https://github.com/mutability/rtl-sdr
#git clone https://github.com/thaolia/librtlsdr-thaolia
#mv librtlsdr-thaolia rtl-sdr
git clone https://github.com/AB9IL/rtl-sdr
mkdir rtl-sdr/build
cd rtl-sdr/build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig

#get r820tweak
echo "\n\n...getting r820tweak..."
cd ~
git clone https://github.com/gat3way/r820tweak
cd r820tweak
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

#get SoapyPlutoSDR support module
echo "\n\n...ADALM-PlutoSDR"
cd ~
git clone https://github.com/jocover/SoapyPlutoSDR
mkdir SoapyPlutoSDR/build
cd SoapyPlutoSDR/build
cmake ..
make
sudo make install
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

#open source sdrplay driver from f4exb
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

#get sdrplay support from osmocom
echo "\n...gr-osmosdr..."
cd ~
#use the original osmocom drivers
#git clone git://git.osmocom.org/gr-osmosdr
#mkdir gr-osmosdr/build
#cd gr-osmosdr/build
#cmake -DENABLE_NONFREE=TRUE ../
#make
#make install
#ldconfig

#else use the hb9fxq fork with better sdrplay support
#git clone https://github.com/krippendorf/gr-osmosdr-fork-sdrplay
#mkdir gr-osmosdr-fork-sdrplay/build
#cd gr-osmosdr-fork-sdrplay/build
#cmake -DENABLE_NONFREE=TRUE ../
#make
#make install
#ldconfig

#else Freeman Pascal's fork with even fresher sdrplay support re api 1.97.1
#cd ~
#git clone https://github.com/Analias/gr-osmosdr-fork-sdrplay
#mkdir gr-osmosdr-fork-sdrplay/build
#cd gr-osmosdr-fork-sdrplay/build
#cmake -DENABLE_NONFREE=TRUE ../
#make
#make install
#ldconfig

#get rtaudio (dependency of SoapyAudio)
echo "\n\n...rtaudio"
cd ~
git clone https://github.com/thestk/rtaudio
#mkdir rtaudio/build
#cd rtaudio/build
#cmake .. -DAUDIO_LINUX_PULSE=ON
cd rtaudio
./autogen.sh --with-pulse
make
make install
ldconfig
cd ~
rm -rf rtaudio

#get the SoapyAudio support module
echo "\n\n...soapy audio"
cd ~
git clone https://github.com/pothosware/SoapyAudio
mkdir SoapyAudio/build
cd SoapyAudio/build
cmake ..
make
make install
ldconfig
cd ~
rm -rf SoapyAudio

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

#install CubicSDR
cd ~
wget "https://github.com/cjcliffe/CubicSDR/releases/download/0.2.3/CubicSDR-0.2.3-x86_64.AppImage"
chmod +x CubicSDR-0.2.3-x86_64.AppImage
mv ~/CubicSDR-0.2.3-x86_64.AppImage /usr/local/sbin/CubicSDR/CubicSDR.AppImage
}

#create menu entry via .desktop file
echo '[Desktop Entry]
Name=CubicSDR
GenericName=CubicSDR
Comment=Software Defined Radio
Exec=/usr/local/sbin/CubicSDR/CubicSDR.AppImage
Icon=/opt/CubicSDR/CubicSDR.ico
Terminal=false
Type=Application
Categories=Network;HamRadio;' > /usr/share/applications/cubicsdr.desktop

#get RemoteSdrClient-NS (for RFSpace hardware)
cd ~
git clone https://github.com/csete/remotesdrclient-ns
cd remotesdrclient-ns
make
#manually copy the binary to /usr/local/bin
cp ~/remotesdrclient-ns/remotesdrclient-ns /usr/local/bin/remotesdrclient-ns
#manually copy the icon to /usr/share/pixmaps
cp ~/remotesdrclient-ns/RemoteSdrClient.png /usr/share/pixmaps/RemoteSdrClient.png
#create menu entry via .desktop file
echo '[Desktop Entry]
Name=RemoteSdrClient
GenericName=RemoteSdrClient
Comment=Remote Client for RFSpace SDRs
Exec=/usr/local/bin/remotesdrclient-ns
Icon=RemoteSdrClient.png
Terminal=false
Type=Application
Categories=Network;HamRadio;' > /usr/share/applications/remotesdrclient.desktop

#get dump1090 for rtl-sdr devices
echo "\n\n...dump1090 for rtl-sdr devices..."
cd ~
#git clone https://github.com/mutability/dump1090
git clone https://github.com/MalcolmRobb/dump1090
cd dump1090
make
mkdir /usr/local/sbin/dump1090
cp -ar public_html /usr/local/sbin/dump1090/public_html
cp -ar testfiles /usr/local/sbin/dump1090/testfiles
cp -ar tools /usr/local/sbin/dump1090/tools
cp dump1090 /usr/local/sbin/dump1090/dump1090
cp view1090 /usr/local/sbin/dump1090/view1090
cp README.md /usr/local/sbin/dump1090/README.md

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

#get rtlsdr-airband
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

cd ~
#get dumpvdl2
git clone https://github.com/szpajder/dumpvdl2
cd dumpvdl2
make
cp ~/dumpvdl2/dumpvdl2 /usr/local/bin/dumpvdl2

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
wget "https://github.com/DSheirer/sdrtrunk/releases/download/v0.3.3-beta.3/sdr-trunk-all-0.3.3-beta.3.jar"
mv sdr-trunk-all-0.3.3-beta.3.jar /usr/local/sbin/sdrtrunk.jar

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
wget "http://physics.princeton.edu/pulsar/k1jt/wsjtx_1.8.0_amd64.deb"
dpkg -i wsjtx_1.8.0_amd64.deb

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
cp ~/files/alsa/asound.state /var/lib/alsa/asound.state
cp ~/files/pulse/daemon.conf /etc/pulse/daemon.conf
cp ~/files/pulse/default.pa /etc/pulse/default.pa
cp ~/files/pulse/system.pa /etc/pulse/system.pa
cp ~/files/networking/resolv.conf /run/resolvconf/resolv.conf
cp ~/files/networking/resolvconf /etc/network/if-up.d/resolvconf
cp ~/files/usr/lib/os-release /usr/lib/os-release
cp -R ~/files/etc/ /etc
cp -R ~/files/usr/local/share/html/ /usr/local/share/html
cp -R ~/files/cjdns/ /etc/skel/cjdns
cp -R ~/files/apps/ /usr/share/applications
cp -R ~/files/icons/ /usr/share/pixmaps
cp -ar ~/files/usr/local/sbin /usr/local/sbin
cp -ar ~/files/openwebrx /usr/local/sbin/openwebrx
cp -ar ~/files/etc/skel /etc/skel

#rename some files to disable services
mv /etc/init/avahi-cups-reload.conf /etc/init/avahi-cups-reload.disabled
mv /etc/init/bluetooth.conf /etc/init/bluetooth.disabled
mv /etc/init/tty3.conf /etc/init/tty3.disabled
mv /etc/init/tty4.conf /etc/init/tty4.disabled
mv /etc/init/tty5.conf /etc/init/tty5.disabled
mv /etc/init/tty6.conf /etc/init/tty6.disabled

#cjdns
echo "\n...CJDNS..."
cd ~
cp ~/files/scripts/cjdns.sh /etc/init.d/cjdns
chmod +x /etc/init.d/cjdns
/etc/init.d/cjdns install
#set link for nodejs and cjdroute
ln -s /usr/bin/nodejs /usr/bin/node
ln -s /opt/cjdns/cjdroute /usr/bin/cjdroute
ln -s /opt/cjdns/contrib/systemd/cjdns.service /etc/systemd/system/cjdns.service

#lantern
wget "https://s3.amazonaws.com/lantern/lantern-installer-beta-64-bit.deb"
dpkg -i lantern-installer-beta-64-bit.deb

#replace the .desktop file
echo '[Desktop Entry]
Type=Application
Name=Lantern
Exec=sh -c "lantern -addr 127.0.0.1:8118"
Icon=lantern
Comment=Censorship circumvention (proxy / vpn) application for unblocked web browsing.
Categories=Network;Internet;Networking;Privacy;Proxy;VPN;' > /usr/share/applications/lantern.desktop

#get the Psiphon client, forked from the pyclient on bitbucket
echo "\nnext, Psiphon (PyClient)"
cd ~
#git clone https://github.com/thispc/psiphon
git clone https://github.com/gilcu3/psiphon
cd /psiphon/openssh-5.9p1
./configure
make
mv ssh ../ssh
cd ../../
cp psiphon /usr/local/sbin/psiphon

#create the launcher file
echo "\n creating the .desktop file..."
echo '[Desktop Entry]
Comment=Psiphon Circumvention (proxy / vpn) controller for unblocked internet.
Exec=gnome-terminal -e '/usr/local/sbin/psiphon-controller.sh'
Name=Psiphon Controller
GenericName[en_US]=Psiphon censorship circumvention controller.
Categories=Network;Internet;Networking;Privacy;psiphon;VPN;proxy;
Icon=/usr/share/pixmaps/psiphon.png
NoDisplay=false
StartupNotify=false
Terminal=0
TerminalOptions=
Type=Application
GenericName[en_US.UTF-8]=Privacy, Cryptography, Circumvention Tools, Psiphon;' > /usr/share/applications/psiphon-controller.desktop

#run volk_profile to optimise for certain sdr apps
echo "\nRunning volk_profile to optimise certain SDR applications"
volk_profile

#blacklist certain kernel drivers
echo "blacklist dvb_usb_rtl28xxu
blacklist e4000
blacklist rtl2832
blacklist rtl2830
blacklist rtl2838
blacklist msi001
blacklist msi2500
blacklist sdr_msi3101" > /etc/modprobe.d/rtl-sdr-blacklist.conf

#set performance configuration in sysctl.conf
echo "
############
vm.swappiness = 10
vm.dirty_ratio = 3
vm.vfs_cache_pressure=50
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
net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf

#configure for realtime audio
echo "@audio - rtprio 95
@audio - memlock 512000
@audio - nice -19" > /etc/security/limits.d/audio.conf

#set performance config in rc.local
echo "#rtc and hpet timers
echo 3072 > /sys/class/rtc/rtc0/max_user_freq
echo 3072 > /proc/sys/dev/hpet/max-user-freq" >> /etc/init.d/rc.local

#move /tmp to ram
cp /usr/share/systemd/tmp.mount /etc/systemd/system/tmp.mount
systemctl enable tmp.mount

#remove development software
apt-get purge unity-tweak-tool squashfs-tools genisoimage

# ldconfig one last time 
ldconfig

echo "\nAll tasks finished!"
