#!/bin/bash

# Copyright (c) 2019 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This script is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Encoding=UTF-8

psiphonstart(){
export http_proxy=
export https_proxy=
echo '//Set the proxy prefs
user_pref("network.proxy.ftp", "127.0.0.1");
user_pref("network.proxy.ftp_port", 8118);
user_pref("network.proxy.http", "127.0.0.1");
user_pref("network.proxy.http_port", 8118);
user_pref("network.proxy.share_proxy_settings", false);
user_pref("network.proxy.socks", "127.0.0.1");
user_pref("network.proxy.socks_port", 1081);
user_pref("network.proxy.ssl", "127.0.0.1");
user_pref("network.proxy.ssl_port", 8118);
user_pref("network.proxy.type", 1);' > /usr/local/etc/firefox/user.js
cd /usr/local/sbin/psiphon/
mate-terminal -e  'sh -c "cd /usr/local/sbin/psiphon/ ; ./psiphon-tunnel-core-i686 -config psiphon.config -serverList remote_server_list -formatNotices; read line"' &
}

psiphonstop(){
sudo killall psiphon-tunnel-core-i686
export http_proxy=
export https_proxy=
echo '//Clear the proxy prefs
user_pref("network.proxy.ftp", "");
user_pref("network.proxy.ftp_port", 0);
user_pref("network.proxy.http", "");
user_pref("network.proxy.http_port", 0);
user_pref("network.proxy.share_proxy_settings", false);
user_pref("network.proxy.socks", "");
user_pref("network.proxy.socks_port", 0);
user_pref("network.proxy.ssl", "");
user_pref("network.proxy.ssl_port", 0);
user_pref("network.proxy.type", 5);' > /usr/local/etc/firefox/user.js
exit
}

ans=$(zenity  --list  --title "PSIPHON CONTROLLER" --width=500 --height=160 \
--text "Start and stop Psiphon" \
--radiolist  --column "Pick" --column "Action" \
FALSE "Start Psiphon and configure Firefox settings." \
TRUE "Stop Psiphon and restore Firefox settings.");

	if [  "$ans" = "Start Psiphon and configure Firefox settings." ]; then
		psiphonstart

	else
		psiphonstop

	fi

