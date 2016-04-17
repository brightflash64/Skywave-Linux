#! /bin/sh
#
#System setup script for Skywave Linux v1.5
#Use on Ubuntu / Mint / Debian
#Run this script as root!

#increase Ubuntu privacy, remove conflicting packages
apt-get remove unity-lens-shopping qt4-default qtmobility-dev libqtmultimediakit1

#blacklist the rtl28xxu kernel driver
echo "blacklist dvb_usb_rtl28xxu
blacklist e4000
blacklist rtl2832" >> /etc/modprobe.d/rtl-sdr-blacklist.conf

echo "\nSetting up repositories..."
#firefox, gqrx, fldigi
add-apt-repository ppa:mozillateam/firefox-next
add-apt-repository ppa:bladerf/bladerf
add-apt-repository ppa:ettusresearch/uhd
add-apt-repository ppa:gpredict-team/daily
add-apt-repository ppa:gqrx/gqrx-sdr
add-apt-repository ppa:kamalmostafa/fldigi
add-apt-repository ppa:myriadrf/drivers
add-apt-repository ppa:myriadrf/gnuradio

#Ubuntu
add-apt-repository multiverse
add-apt-repository universe
add-apt-repository wily-backports
add-apt-repository wily-proposed
add-apt-repository wily-updates

# get everything that we want from the repositories
echo "\nGetting packages from the repositories..."
apt-get update
apt-get upgrade
apt-get -y install $(grep -vE "^\s*#" newsoftware  | tr "\n" " ")
echo "\nFinished installing software from the repositories."
echo "\nStarting installation from source code.  Please stand by..."

#get qtradio
echo "\nFirst, QtRadio..."
cd ~
git clone git://github.com/alexlee188/ghpsdr3-alex.git
cd ghpsdr3-alex
make distclean
sh cleanup.sh
git checkout master
autoreconf -i
./configure
make -j4 all
make install

#install rtl-sdr drivers
echo "\nnext, rtl-sdr firmware..."
cd ~
git clone git://git.osmocom.org/rtl-sdr.git
cd rtl-sdr
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig


#install cudaSDR
echo "\nnext, cudaSDR..."
cd ~
git clone git://github.com/n1gp/cudaSDR.git
cd cudaSDR
mkdir build
cd build
qmake cudaSDR.pro
cp ~/cudaSDR/Source/bin/cudaSDR /usr/local/bin/cudaSDR
cp ~/cudaSDR/Source/bin/settings.ini /usr/local/bin/settings.ini

#install rtl_hpsdr
#build librtlsdr, but only keep rtl_hpsdr
echo "\nnext, rtl_hpsdr..."
cd ~
git clone git://github.com/n1gp/librtlsdr.git
cd librtlsdr
mkdir build
cd build
cmake ..
make
cp ~/librtlsdr/build/src/rtl_hpsdr /usr/local/bin/rtl_hpsdr

#get dump1090
echo "\nnext, dump1090..."
cd ~
#git clone git://github.com/mutability/dump1090.git
git clone git://github.com/MalcolmRobb/dump1090.git
cd dump1090
make
mkdir /usr/local/sbin/dump1090
cp -ar ~/dump1090/public_html /usr/local/sbin/dump1090/public_html
cp ~/dump1090/testfiles /usr/local/sbin/dump1090/testfiles
cp ~/dump1090/tools /usr/local/sbin/dump1090/tools
cp ~/dump1090/dump1090
cp ~/dump1090/view1090
cp ~/dump1090/LICENSE
cp ~/dump1090/README.md
cp ~/dump1090/README-dump1090.md
cp ~/dump1090/README-json.md

#create the dump1090 startup script
echo '#!/bin/bash
start() {
sudo echo "

// --------------------------------------------------------
//
// This file is to configure the configurable settings.
// Load this file before script.js file at gmap.html.
//
// --------------------------------------------------------

// -- Title Settings --------------------------------------
// Show number of aircraft and/or messages per second in the page title
PlaneCountInTitle = true;
MessageRateInTitle = false;

// -- Output Settings -------------------------------------
// Show metric values
// The Metric setting controls whether metric (m, km, km/h) or
// imperial (ft, NM, knots) units are used in the plane table
// and in the detailed plane info. If ShowOtherUnits is true,
// then the other unit will also be shown in the detailed plane
// info.
Metric = false;
ShowOtherUnits = true;

// -- Map settings ----------------------------------------
// These settings are overridden by any position information
// provided by dump1090 itself. All positions are in decimal
// degrees.

// Default center of the map.
DefaultCenterLat = "$latitude";
DefaultCenterLon = "$longitude";
// The google maps zoom level, 0 - 16, lower is further out
DefaultZoomLvl   = 7;

// Center marker. If dump1090 provides a receiver location,
// that location is used and these settings are ignored.

SiteShow    = false;           // true to show a center marker
SiteLat     = "$latitude";            // position of the marker
SiteLon     = "$longitude";
SiteName    = "My Radar Site"; // tooltip of the marker


// Extra map types to include. These work for maps with 256x256 tiles where a
// URL can be constructed by simple substition of x/y tile number and zoom level
var ExtraMapTypes = {
        "OpenStreetMap"    : "http://tile.openstreetmap.org/{z}/{x}/{y}.png",
        // NB: the following generally only cover the US
        "Sectional Charts" : "http://wms.chartbundle.com/tms/1.0.0/sec/{z}/{x}/{y}.png?origin=nw",
        "Terminal Charts"  : "http://wms.chartbundle.com/tms/1.0.0/tac/{z}/{x}/{y}.png?origin=nw",
        "World Charts"     : "http://wms.chartbundle.com/tms/1.0.0/wac/{z}/{x}/{y}.png?origin=nw",
        "IFR Low Charts"   : "http://wms.chartbundle.com/tms/1.0.0/enrl/{z}/{x}/{y}.png?origin=nw",
        "IFR Area Charts"  : "http://wms.chartbundle.com/tms/1.0.0/enra/{z}/{x}/{y}.png?origin=nw",
        "IFR High Charts"  : "http://wms.chartbundle.com/tms/1.0.0/enrh/{z}/{x}/{y}.png?origin=nw"
};


// -- Marker settings -------------------------------------

// These settings control the coloring of aircraft by altitude.
// All color values are given as Hue (0-359) / Saturation (0-100) / Lightness (0-100)
ColorByAlt = {
        // HSL for planes with unknown altitude:
        unknown : { h: 0,   s: 0,   l: 40 },

        // HSL for planes that are on the ground:
        ground  : { h: 120, s: 100, l: 30 },

        air : {
                // These define altitude-to-hue mappings
                // at particular altitudes; the hue
                // for intermediate altitudes that lie
                // between the provided altitudes is linearly
                // interpolated.
                //
                // Mappings must be provided in increasing
                // order of altitude.
                //
                // Altitudes below the first entry use the
                // hue of the first entry; altitudes above
                // the last entry use the hue of the last
                // entry.
                h: [ { alt: 2000,  val: 20 },    // orange
                     { alt: 10000, val: 140 },   // light green
                     { alt: 40000, val: 300 } ], // magenta
                s: 85,
                l: 50,
        },

        // Changes added to the color of the currently selected plane
        selected : { h: 0, s: -10, l: +20 },

        // Changes added to the color of planes that have stale position info
        stale :    { h: 0, s: -10, l: +30 },

        // Changes added to the color of planes that have positions from mlat
        mlat :     { h: 0, s: -10, l: -10 }
};

// For a monochrome display try this:
// ColorByAlt = {
//         unknown :  { h: 0, s: 0, l: 40 },
//         ground  :  { h: 0, s: 0, l: 30 },
//         air :      { h: [ { alt: 0, val: 0 } ], s: 0, l: 50 },
//         selected : { h: 0, s: 0, l: +30 },
//         stale :    { h: 0, s: 0, l: +30 },
//         mlat :     { h: 0, s: 0, l: -10 }
// };

// Outline color for aircraft icons with an ADS-B position
OutlineADSBColor = "#000000";

// Outline color for aircraft icons with a mlat position
OutlineMlatColor = "#4040FF";

SiteCircles = true; // true to show circles (only shown if the center marker is shown)
// In nautical miles or km (depending settings value "Metric")
SiteCirclesDistances = new Array(100,150,200);

// Show the clocks at the top of the righthand pane? You can disable the clocks if you want here
ShowClocks = true;

// Controls page title, righthand pane when nothing is selected
PageName = "DUMP1090";

// Show country flags by ICAO addresses?
ShowFlags = true;

// Path to country flags (can be a relative or absolute URL; include a trailing /)
FlagPath = "flags-tiny/";
" > /usr/local/sbin/dump1090/public_html/config.js

cd /usr/local/sbin/dump1090/
./dump1090 --net --interactive --aggressive --oversample --phase-enhance &
firefox --new-tab http://127.0.0.1:8080
}

IFS="," read -p "Please enter your latitude,longitude (degrees.decimals).
For example, in New York you enter 40.7, -74.0

> " latitude longitude

start
' > /usr/local/sbin/dump1090/dump1090.sh
chmod +x dump1090.sh

#create menu entry via .desktop file
echo '
[Desktop Entry]
Name=Dump1090
GenericName=dump1090
Comment=Mode S SDR
Exec=gnome-terminal -e "sh /usr/local/sbin/dump1090/dump1090.sh"
Icon=terminal
Terminal=false
Type=Application
Categories=Network;HamRadio;' > /usr/share/applications/dump1090.desktop

#get wxtoimg
echo "\nnext, WxtoImg..."
cd ~
wget -O - "http://www.wxtoimg.com/beta/wxtoimg-amd64-2.11.2-beta.deb"
dpkg -i wxtoimg-amd64-2.11.2-beta.deb

#install CubicSDR and dependencies
#get liquid-dsp
echo "\nnext, liquid-dsp"
cd ~
git clone https://github.com/jgaeddert/liquid-dsp
cd liquid-dsp
./bootstrap.sh
./configure
make
make install
ldconfig

#get SoapySDR
echo "\nnext, SoapySDR"
cd ~
git clone https://github.com/pothosware/SoapySDR.git
cd SoapySDR
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
make install
ldconfig

#get CubicSDR
echo "\nnext, CubicSDR..."
cd ~
git clone https://github.com/cjcliffe/CubicSDR.git
cd CubicSDR
mkdir build
cd build
cmake ../
make

#move it to /opt
mkdir /opt/CubicSDR
cp -ar ~/CubicSDR/build/x64 /opt/CubicSDR

#create menu entry via .desktop file
echo "[Desktop Entry]
Name=CubicSDR
GenericName=CubicSDR
Comment=Software Defined Radio
Exec=/opt/CubicSDR/CubicSDR
Icon=/opt/CubicSDR/CubicSDR.ico
Terminal=false
Type=Application
Categories=Network;HamRadio;" > /usr/share/applications/cubicsdr.desktop

#install readsea
echo "\nnext, Redsea..."
cd ~
git clone git://github.com/windytan/redsea.git
cd redsea
git checkout master
make
makeinstall

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

#get WSJT-X
echo "\nnext, WSJT-X..."
cd ~
wget -O - "http://physics.princeton.edu/pulsar/k1jt/wsjtx_1.6.0_amd64.deb"
dpkg -i wsjtx_1.6.0_amd64.deb

#get WSPR-X
echo "\nnext, WSPR-X"
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
cp /files/apt/10periodic /etc/apt/apt.conf.d/10periodic
cp /files/iradio-initial.xspf /usr/share/rhythmbox/plugins/iradio/iradio-initial.xspf
cp /files/alsa/asound.state /var/lib/alsa/asound.state
cp /files/pulse/daemon.conf /etc/pulse/daemon.conf
cp /files/pulse/default.pa /etc/pulse/default.pa
cp /files/pulse/system.pa /etc/pulse/system.pa
cp /files/networking/resolv.conf /run/resolvconf/resolv.conf
cp /files/networking/resolvconf /etc/network/if-up.d/resolvconf
cp /files/etc/asound.conf /etc/asound.conf
cp /files/etc/issue /etc/issue
cp /files/etc/issue.net /etc/issue.net
cp /files/etc/legal /etc/legal
cp /files/etc/lsb-release /etc/lsb-release
cp /files/etc/os-release /etc/os-release
cp /files/scripts/cjdns-controller.sh /usr/local/sbin/cjdns-controller.sh
cp /files/scripts/redsea-controller.sh /usr/local/sbin/redsea-controller.sh
cp /files/scripts/rtl-hpsdr-controller.sh /usr/local/sbin/rtl-hpsdr-controller.sh
cp /files/scripts/rtlsdr-controller.sh /usr/local/sbin/rtlsdr-controller.sh
cp /files/scripts/softrock-controller.sh /usr/local/sbin/softrock-controller.sh
cp /files/scripts/websdr-list.sh /usr/local/sbin/websdr-list.sh
cp /files/cjdns/cjdns_peers_ipv4 /etc/skel/cjdns/cjdns_peers_ipv4
cp /files/cjdns/cjdns_peers_ipv6 /etc/skel/cjdns/cjdns_peers_ipv6
cp /files/cjdns/cjdns_peers_ipv4_link /usr/local/sbin/cjdns/cjdns_peers_ipv4
cp /files/cjdns/cjdns_peers_ipv6_link /usr/local/sbin/cjdns/cjdns_peers_ipv6
cp /files/apps/cjdns-controller.desktop /usr/share/applications/cjdns-controller.desktop
cp /files/apps/bitmask.desktop /usr/share/applications/bitmask.desktop
cp /files/apps/cubicsdr.desktop /usr/share/applications/cubicsdr.desktop
cp /files/apps/cudasdr.desktop /usr/share/applications/cudasdr.desktop
#cp /files/apps/dump1090.desktop /usr/share/applications/dump1090.desktop
cp /files/apps/nautilus-root.desktop /usr/share/applications/nautilus-root.desktop
#cp /files/apps/redsea-controller.desktop /usr/share/applications/redsea-controller.desktop
cp /files/apps/rtl-hpsdr-controller.desktop /usr/share/applications/rtl-hpsdr-controller.desktop
cp /files/apps/rtlsdr-controller.desktop /usr/share/applications/rtl-hpsdr-controller.desktop
cp /files/apps/skywavelinux.desktop /usr/share/applications/skywavelinux.desktop
cp /files/apps/softrock-controller.desktop /usr/share/applications/softrock-controller.desktop
cp /files/apps/wsjtx.desktop /usr/share/applications/wsjtx.desktop
cp /files/apps/wsprx.desktop /usr/share/applications/wsprx.desktop
cp /files/apps/wxtoimg.desktop /usr/share/applications/wxtoimg.desktop
cp /files/icons/Cjdns_logo.png /usr/share/pixmaps/Cjdns_logo.png
cp /files/icons/CQ.png /usr/share/pixmaps/CQ.png
cp /files/icons/CudaSDR.png /usr/share/pixmaps/CudaSDR.png
cp /files/icons/wsjtx_icon.png /usr/share/pixmaps/wsjtx_icon.png
cp /files/icons/wxtoimg.png /usr/share/pixmaps/wxtoimg.png
cp /files/opt/iccpr.html /opt/iccpr.html
cp /files/opt/skywavelinux.html /opt/skywavelinux.html
cp /files/opt/textpage.css /opt/textpage.css

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

echo "\nAll tasks finished!"
