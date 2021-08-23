#!/bin/sh
 
while getopts "h:u:p:" OPTION
do
   case $OPTION in
      h) server=$OPTARG
         ;;
      u) user=$OPTARG
         ;;
      p) password=$OPTARG
      	 ;;
      *) error="true"; echo -e "Incorrect parameter, please use the options below:\n-h Controller host\n-u API user\n-p API password"
   esac
done

if [ -z $server ] || [ -z $user ] || [ -z $password ]; then

	if [ -z $error ]; then
		echo -e "All parameters must be declared, please use the options below:\n-h Controller host\n-u API user\n-p API password"
	fi
else
	opkg update
	opkg remove wpad wpad-basic
	opkg install wpad-mini bash bc curl
	mkdir /usr/share/controller
	mkdir /usr/share/controller/scripts
	mkdir /usr/share/controller/api
	chmod +x ./scripts/*.sh
	uci delete wireless.radio0.disabled
	uci delete wireless.@wifi-iface[0].disabled
	uci set wireless.@wifi-iface[0].macfilter=deny
	cp ./scripts/*.sh /usr/share/controller/scripts/
	echo "manual" > /usr/share/controller/scripts/channel_mode
	echo $server > /usr/share/controller/api/server
	echo $user > /usr/share/controller/api/user
	echo $password > /usr/share/controller/api/password
	cat ./cron/cron.conf | crontab -
	/etc/init.d/cron enable
	/etc/init.d/cron restart
	uci commit wireless
	wifi
fi
