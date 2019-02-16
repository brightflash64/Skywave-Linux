#!/bin/bash

# Copyright (c) 2019 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This script is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Encoding=UTF-8

lanternstart(){
export http_proxy=
export https_proxy=
echo '//configure the proxy prefs
user_pref("network.proxy.ftp", "");
user_pref("network.proxy.ftp_port", 0);
user_pref("network.proxy.http", "127.0.0.1");
user_pref("network.proxy.http_port", 8118);
user_pref("network.proxy.share_proxy_settings", true);
user_pref("network.proxy.socks", "");
user_pref("network.proxy.socks_port", 0);
user_pref("network.proxy.ssl", "127.0.0.1");
user_pref("network.proxy.ssl_port", 8118);
user_pref("network.proxy.type", 1);' > /usr/local/etc/firefox/user.js
lantern -addr=127.0.0.1:8118
}

lanternstop(){
killall -9 lantern
export http_proxy=
export https_proxy=
echo '//clear the proxy prefs
user_pref("network.proxy.ftp", "");
user_pref("network.proxy.ftp_port", 0);
user_pref("network.proxy.http", "");
user_pref("network.proxy.http_port", 0);
user_pref("network.proxy.share_proxy_settings", true);
user_pref("network.proxy.socks", "");
user_pref("network.proxy.socks_port", 0);
user_pref("network.proxy.ssl", "");
user_pref("network.proxy.ssl_port", 0);
user_pref("network.proxy.type", 5);' > /usr/local/etc/firefox/user.js
exit
}

ans=$(zenity  --list  --title "LANTERN CONTROLLER" --width=500 --height=160 \
--text "Start and stop Lantern" \
--radiolist  --column "Pick" --column "Action" \
FALSE "Start Lantern and configure Firefox settings." \
TRUE "Stop Lantern and restore Firefox settings.");

	if [  "$ans" = "Start Lantern and configure Firefox settings." ]; then
		lanternstart

	else
		lanternstop

	fi

