#**Skywave Linux v1.5**  
##*Software Defined Radio for Online Listening*   


skywavelinux-1.5.iso:  
md5sum: 3589b0ece1ae314e2a1ce84142725756  
sha1sum: 43b998045ab2d271a7bad98b8d97d78452b96360  

Welcome to the 1.5 update of Skywave Linux!  This is an operating system designed to provide access to a growing network of software defined radios all over the world.  With global SDR access, shortwave listeners can access broadcast, utility, amateur radio, military, and other signals from almost anywhere in the world - from state-of-the art radio servers.  All you need to do is boot Skywave Linux on a computer with internet access.

Why was Skywave Linux created? The developer of this system, plagued by a lack of access to quality radio broadcasts due to his residence in a country practising tight media control and censorship, sought a means to access free and diverse radio content. In addition, software defined radio offered an exciting way to experience the hobby of shortwave listening. By connecting to remote radio servers on the internet, it is possible to enjoy bleeding edge radio operation without large antennas or setting up a station on-site. Installing SDR software can be difficult for many computer users, and Skywave Linux eliminates the hassle of downloading, compiling, and configuring apps for the SDR servers on the internet.

**Supported SDR Types**

Four types of software defined radio are supported by Skywave Linux:

 - HPSDR hardware, for internet accessible receivers, is covered by QtRadio. Several servers are online 24 hours a day, and cover spectrum from LF through low UHF. Performance is excellent from these servers, and the radio configuration options in QtRadio make for a "professional grade" operating experience.

 - WebSDR servers are located all over the world and provide easy access to the global airwaves via web browser. In Skywave Linux, use the launcher to open Firefox at the WebSDR index page.  A modern web browser is all one needs to enjoy clean, stable, AM / FM / SSB reception using this cutting edge technology. The servers at University of Twente (NL), K2SDR, New Jersey (USA), and G4FPH, Stafford (UK) are particularly good.

 - OpenWebRX servers are a new type of internet accessible SDR, located in a few locations around the world. They work well and more servers are expected to go online in 2016.  Try the Victoria, British Columbia (Canada) site to experience OpenWebRX.

 - RTL-SDR devices used on the local system. Just plug-and-play! Try the Victoria, British Columbia (Canada) site to experience OpenWebRX. QtRadio (via the RTL-SDR controller script) offers advanced noise reduction and very high quality AM / SSB / CW reception, plus FM up to a 200 kHz bandwidth. Dump1090 (Mutability version) is for monitoring aircraft ADS-B transmissions. ADS-B mapping is available from Dump1090's built in webserver.

For decoding RTTY, CW, PSK, WSJT, WSPR, RDS, and other digital radio transmission modes, the Fldigi the WSJT applications are installed. Simply start the applicatio and tune in a signal on the waterfall to decode. Weather satellite decoding is possible with the very capable WXtoImg application. Gpredict provides real-time satellite tracking data and doppler corrected tuning control for Gqrx. In some cases it may be necessary to use the Pulseaudio Preferences or Volume Control applications to configure the audio (output from the LADSPA audio processor plugins, networked sound, etc).

Two experimental applications, cudaSDR and OpenHPSDRJ are installed, expanding the support in Skywave Linux for High Performance Software Defined Radio. Both offer automatic discovery of connected hardware and advanced operating features.

Conventional radio broadcast streams are also supported. There are plenty of stations preloaded in the Rhythmbox music player. Music, talk, news, free-speech, and religious stations are included.

**Usage and Installation**

Use Skywave Linux as you would use any live Linux system:

 - Burn it to a DVD and run it as a boot disc (slow).

 - Create a bootable USB or SD card using Universal USB Installer or YUMI (Windows users).

 - In Linux, create a bootable USB or SD card using Unetbootin.

 - In Linux, simply install a bootloader and copy the iso file to a USB or SD card.

 - Install it to the hard drive as the main operating system.

**Technical Notes**

Skywave Linux v1.4 is built on a base of state-of-the-art Ubuntu 15.10, uses the Unity desktop environment, and draws on the capabilities of Ubuntu: software updating, graphics, system resource management, etc. It is the additional digital signal processing, networking, and signal decoding applications that set Skywave Linux apart from stock Ubuntu Linux.

The radio software is largely compiled from source code and can be updated by end users with moderate computer skills, though Skywave Linux is designed for easy use by radio operators with basic computer skills. In fact, Skywave Linux was created to open the world of HPSDR and RTL-SDR operating to people who enjoy high performance radio but are not computer experts.

It may sometimes be advantageous for users to use encrypted connections which provide stronger privacy, security, and ability to circumvent censorship. For that purpose, the Bitmask and Lantern VPN applications are installed. In addition, basic PPTP and OpenVPN connections are included in the networking applet.

**Acknowledgements**

Skywave Linux thanks the talented developers who create Ubuntu, QtRadio, Cubic SDR, Dump1090, Fldigi, WebSDR, WSJT, and the many other components necessary for this distribution to exist. Skywave Linux also thanks the end users for selecting this distribution and hopes it is an asset to their radio monitoring endeavors.

**Disclaimer**

Some parts of the world suffer from governance by regimes restricting the human right to freedoms of speech, including radio or electronic emedia access. If you are in such a restrictive place, and subject to punishment for listening to foreign media, military communications, or other signals available through Skywave Linux, you do so at your own risk. Be careful and do not get caught! Use a VPN to encrypt your internet activity. Shield and disguise your RTL-SDR hardware from rats and snitches. Skywave Linux, its developers and distributors, are not responsible for the monitoring activities of end users. We will never discourage accessing the network of software defined radio servers, but do encourage self-protective measures by anyone living under restrictive regulation.  Skywave Linux is not endorsed by or affiliated with Ubuntu / Canonical. Ubuntu is simply used as a foundation for building Skywave Linux.

**Changelog**

Version 1.5:

>Added Gqrx 2.5.3
>Added Gpredict 1.4
>Added WXtoImg 2.11.2
>Updated WebSDR Server List
>Upgraded CubicSDR 0.1.26
>Upgraded Firefox 45
>Upgraded Fldigi 3.23.08
>Upgraded Lantern 2.1.1
>Upgraded WSJT-X 1.6.0
>Upgraded Linux kernel 4.2.0-34-generic

Version 1.4:
>Changed default username and hostname to "skywave"
>Upgraded Firefox 43
>Upgraded CubicSDR 0.1.4
>Removed LibreOffice
>Activated Dump1090 phase-enhancement and oversampling options
>Added Java (OpenJDK) Runtime Environment 1.8.0
>Added CudaSDR 0.3.2.13 with RTL_HPSDR support

Version 1.3:
>Ubuntu 15.10 base system, kernel 4.2.0-19-generic
>Upgraded Bitmask 0.9.1
>Upgraded Firefox 42
>Upgraded LibreOffice 5.0.2
>Upgraded WSJT-X 1.6-rc1
>Enabled pulseaudio daemon and networked sound
>Adjusted settings in QtRadio for Softrocks and RTL-SDR hardware
>Added Lantern 2.0.10
>Added stations to Rhythmbox
>Added servers to WebSDR Server List

Version 1.2:
>Activated ZRAM kernel module for better performance  
>Adjusted settings in QtRadio  
>Added stations to Rhythmbox  

Version 1.1:
>FM Broadcast RDS decoding via Redsea  
>Added WSJT / WSPR weak signal digimodes  
>Added Selectable WebSDR List  
>Improved Softrock support in QtRadio  

Version 1.0:
>Ubuntu 14.10 base system, kernel 3.16.0-23-generic  
>Firefox 33  
>LibreOffice 4.3  
>QT Radio / GHPSDR3-Alex 04/26/2015  
>CubicSDR 0.1.3  
>Fldigi  
>Dump1090-Mutability v1.14-25  
>Bitmask 0.8  

