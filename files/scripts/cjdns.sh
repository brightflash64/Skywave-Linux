#!/bin/bash
### BEGIN INIT INFO
# cjdns.sh - An init script (/etc/init.d/) for cjdns
# Provides:          cjdns
# Required-Start:    $remote_fs $network
# Required-Stop:     $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Cjdns router
# Description:       A routing engine designed for security, scalability, speed and ease of use.
# cjdns git repo:    https://github.com/cjdelisle/cjdns
### END INIT INFO

#### NOTES:
# This is a modified version of (https://gist.github.com/3030662).
# You can run the script
# sh cjdns.sh (start|stop|restart|status|scan|hypedns|flush|update|autoupdate|install|delete|version)
# Suggested script install:
# I recommend that you create a soft link in your /etc/init.d/ folder, for example run:
# sudo ln -s /path/to/script/cjdns.sh /etc/init.d/cjdns
# 
# Then you can run the following in terminal with one of the choices below:
# sudo /etc/init.d/cjdns (start|stop|restart|status|scan|hypedns|flush|update|autoupdate|install|delete|version)
#
# Install cjdns (download cjdns.sh) 
# Run in terminal:
# sudo ln -s /path/to/script/hyperboria.sh /etc/init.d/cjdns
# chmod +x /etc/init.d/cjdns
# sudo /etc/init.d/cjdns install
#
# Add peers when prompted (optional) and save. 
# To start cjdns:
# sudo /etc/init.d/cjdns start
####

# Stuff you will probably need to change
GIT_PATH="/opt/cjdns"
PROG_PATH="/opt/cjdns"
CJDNS_CONFIG="/etc/cjdroute.conf"

# Stuff you might need to change
CJDNS_BUILD_USER="root"
CJDNS_RUN_USER="root"                       #see wiki about changing this user to a service user.

# Stuff you most likely will not need to change
PROG="cjdroute"
CJDNS_LOGFOLDER="/var/log/cjdns"        # if you are using /dev/null, dont change this to /dev/ or /dev/null
CJDNS_LOG="/var/log/cjdns/cjdroute.log" # use /dev/null here if you do not want any logs. You d not need to change $CJDNS_LOGFOLDER when using /dev/null
CJDNS_RUNAS="nobody"                    # default value from cjdns
CJDNS_IFACE="tun0"                      # if you already have a tun0 interface, set this to whichever will become your cjdns one. tun0 is the default.
SCRIPT_VERSION=4                        # Internal version number that may be used eventually

start() {
     # Start it up with the user cjdns
     if check; 
     then
          if [ ! -d $CJDNS_LOGFOLDER ]; 
          then
               echo "Creating log folder..."
               su $CJDNS_RUN_USER -c "mkdir -p $CJDNS_LOGFOLDER"
          fi
          if [ ! -f $CJDNS_LOG ]; 
          then
               echo "Creating log file..."
               su $CJDNS_RUN_USER -c "touch $CJDNS_LOG"
          fi    
          echo "**Cleaning old logs"
          su $CJDNS_RUN_USER  -c "cat /dev/null > $CJDNS_LOG"
          echo "**Starting cjdroute"
          su $CJDNS_RUN_USER -c "$PROG_PATH/$PROG < $CJDNS_CONFIG >> $CJDNS_LOG"
     else
          echo "cjdns is already running. Doing nothing..."
     fi
 }

 stop() {
     if check; 
     then
         echo "cjdns isn't running."
     else
         echo "Killing cjdns"
         killall -u $CJDNS_RUNAS cjdns
     fi
 }

 flush() {
     if [ "$(dirname $CJDNS_LOG)" = "$CJDNS_LOGFOLDER" ;] 
     then
         echo
         echo "Cleaning log file, leaving last 100 rows\n"
         tail -100 $CJDNS_LOG > .tmp_cjdns_log && mv .tmp_cjdns_log $CJDNS_LOG
     else
         echo 
         echo "Your log file, $(basename $CJDNS_LOG), is not in $CJDNS_LOGFOLDER, nothing will be flushed."
         echo "If you are using /dev/null as a log file, to avoid logging, this is normal."
         echo "If you are trying to log, please check CJDNS_LOGFOLDER and CJDNS_LOGFOLDER"
         echo "in the script."
         echo
     fi
 }

 status() {
     if check; then
          echo "* cjdns is not running"
     else
          echo "* cjdns is running"
     fi
 }

check() {
     if [ $(pgrep -u $CJDNS_RUNAS cjdns | wc -l) != 0 ]; then
         #echo "running"
         return 1
     else
         #echo "not running"
         return 0
     fi
 }

update() {
   if [ "`su - $CJDNS_BUILD_USER -c \"cd $GIT_PATH || exit 1 && git pull 2>&1\" | grep 'Already up-to-date.'`" == "" ];
   then
        echo "-Got new stuff from git. Rebuilding."
        BUILD_TEXT=`su - $CJDNS_BUILD_USER -c "cd $GIT_PATH || exit 1 && ./do 2>&1"`
        if [ "`echo \"$BUILD_TEXT\" | tail -1 | grep 'Failed to build cjdns.'`" == "" ];
        then
             echo "-Cjdns build complete"
             if [ "$RESTART_CJDNS" == "true" ];
             then
               stop
               until check; do sleep 1; done
               start 
             fi 
        else 
             echo "$BUILD_TEXT"
             return 1
        fi
   fi
}

setup() {
  echo "Create cjdns installation folder if it does not exist: $GIT_PATH."
  su - $CJDNS_BUILD_USER -c "mkdir -p $GIT_PATH"
  
  echo "Ensuring you have the required software: cmake make git build-essential nano"
  apt-get install -y cmake make git build-essential nmap nano nodejs
  # If you dont want nano, you can delete "nano" above but you must then change "nano" below to your prefered text editor.
  # nmap is required for the scan function of this script
  echo "Getting the cjdns source code from github..."
  cd $GIT_PATH/../
  su - $CJDNS_BUILD_USER -c "git clone https://github.com/cjdelisle/cjdns.git $GIT_PATH"
  if [[ $? -ne 0 ]] ; then
    echo
    echo "Looks like you've already downloaded cjdns, I'm going to try to update in case we were interrupted the last time you tried."
    echo "Press enter to continue or control-c to exit"
    read -e TRASH
    su - $CJDNS_BUILD_USER -c "cd $GIT_PATH && git pull"
    if [[ $? -ne 0 ]] ; then
      exit 1
    fi
  fi

  echo "Compiling cjdns..."
  cd $GIT_PATH
  su - $CJDNS_BUILD_USER -c "$GIT_PATH/do"
  if [[ $? -ne 0 ]] ; then
    echo
    echo "Error compiling cjdns. Please seek help in #cjdns on efnet IRC"
    exit 1
  fi

  if [ -f $CJDNS_CONFIG ]; #check if config file already exists.
  then
    echo
    echo "Config file ($CJDNS_CONFIG) already exists." 
    echo "To generate a new config file run:" 
    echo "~:$ /opt/cjdns/cjdroute --generate > $CJDNS_CONFIG"
    echo
  else
    echo
    echo "There is not config file ($CJDNS_CONFIG) detected. "
    echo "**Generating a config file ($CJDNS_CONFIG)..."
    echo
    su - $CJDNS_BUILD_USER -c "$GIT_PATH/cjdroute --genconf > $CJDNS_CONFIG"
    echo
    echo "Press enter to open your configuration file to add peers:"
    read -e TRASH
    su - $CJDNS_BUILD_USER -c "${FCEDIT:-${VISUAL:-${EDITOR:-nano}}} $CJDNS_CONFIG"

  fi

  echo "Making a log dir ($CJDNS_LOGFOLDER)"
  mkdir -p $CJDNS_LOGFOLDER
  echo
  echo "You should be ready to start cjdns now! Just re-run this script with 'start' instead of 'install'"
  echo
 }

delete() {
	echo 
	echo "[**WARNING**]"
	echo "Are you SURE your want to DELETE cjdns from this system?"
  echo "NOTE: this will not delete the config file($CJDNS_CONFIG)"
  read -p "(Y|y|N|n): " choice
	case "$choice" in 
	  y|Y ) 
		  echo "**Stopping cjdns..."
		  stop 
		  sleep 3
		  echo
		  echo "**Deleting cjdns files from your system ($GIT_PATH, $CJDNS_LOGFOLDER)  "
		  sleep 2
      find $GIT_PATH/* -not -name 'cjdroute.conf' | xargs rm -rf # Don't delete cjdroute.conf if its in $GIT_PATH
      rm -rf $CJDNS_LOGFOLDER
		  echo
		  echo "Your configuration file ($CJDNS_CONFIG) still exists."
		  echo "You many want to keep this for later use.  You can also"
		  echo "delete the soft link if you created one i.e., /etc/init.d/cjdns."
		  echo
		;;
	    n|N ) 
		  echo "**Exiting uninstall of cjdns. You have done nothing :)..."
		;;
	   * ) echo "**Invalid response. You have done nothing :)..."
		;;
	esac

}

hypedns() {
     echo 'nameserver fc5d:baa5:61fc:6ffd:9554:67f0:e290:7535' | resolvconf -a $CJDNS_IFACE
}

scan() {
     #there is a better way to get the IP via ip addr but I already had this worked up before I found out about that. Feel free to improve :)
     CJDNS_IFACE_IP=`/sbin/ifconfig $CJDNS_IFACE | sed -n '2 p' | awk '{print $3}' | cut -d '/' -f 1`
     NMAP_PORTS=`nmap -6 -n -r -p1-65535 -sT -oG - $CJDNS_IFACE_IP  | grep '/open/' | cut -f 2  | awk -F 'Ports: ' '{print $2}'`
   
     if [ -z "$NMAP_PORTS" ]; then
          echo "No open ports found!"
     else
          OIFS=$IFS;
          IFS=", ";
          echo "Open ports:"
          for v in ${NMAP_PORTS}; do 
               NUM=`echo $v | cut -d / -f 1`
               TYPE=`echo $v | cut -d / -f 3`
               SERVICE=`echo $v | cut -d / -f 5`
               if [ -z "$NMAP_PORTS" ]; then
                    echo "$NUM $TYPE"
               else
                    echo "$NUM $TYPE ($SERVICE)"
               fi
          done
          IFS=$OIFS;
     fi 
}

 ## Check to see if we are running as root first.
 if [ "$(id -u)" != "0" ]; then
     echo "This script must be run as root" 1>&2
     exit 1
 fi

 case $1 in
     hypedns)
          hypedns
     ;;
     scan)
          scan
     ;;
     start)
         start
     ;;
     stop)
         stop
     ;;
     reload|restart|force-reload)
          stop
          until check; do sleep 1; done
          start
     ;;
     status)
         status
     ;;
     flush)
         flush
     ;;
     autoupdate|autoupgrade)
         RESTART_CJDNS="true"
         update
     ;;
     update|upgrade)
         update 
     ;;
     install|setup)
         setup
     ;;
     delete)
         delete
     ;;
     version)
         echo $SCRIPT_VERSION
     ;;
     **)
         echo "Usage: $0 (start|stop|restart|status|scan|hypedns|flush|update|autoupdate|install|delete|version)" 1>&2
         exit 1
     ;;
 esac