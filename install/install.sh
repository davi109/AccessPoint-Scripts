#!/bin/sh
 
while getopts "h:u:p:" OPTION
do
   case $OPTION in
      h) server=$OPTARG
         ;;
      u) user=$OPTARG
         ;;
      a) password=$OPTARG
      	 ;;
      p) port=$OPTARG
      ;;
      *) error="true"; echo -e "Incorrect parameter, please use the options below:\n-h Controller host\n-u API user\n-p API password"
   esac
done

if [ -z $server ] || [ -z $user ] || [ -z $password ] || [ -z $port ]; then

	if [ -z $error ]; then
		echo -e "All parameters must be declared, please use the options below:\n-h Controller host\n-u API user\n-p API password"
	fi
else
	opkg update
	opkg remove wpad wpad-basic
	opkg install unzip wpad-mini bash bc
	mkdir /usr/share/controller
	mkdir /usr/share/controller/scripts
	mkdir /usr/share/controller/api
	curl -LJO https://github.com/davi109/ap_scripts/archive/refs/heads/main.zip
	unzip AccessPoint-Scripts-main.zip
	chmod +x ./AccessPoint-Scripts-main/scripts/*.sh
	uci delete wireless.radio0.disabled
	uci delete wireless.@wifi-iface[0].disabled
	uci set wireless.@wifi-iface[0].macfilter=deny
	uci set wireless.radio1.disabled='1'
	cp ./AccessPoint-Scripts-main/scripts/*.sh /usr/share/controller/scripts/
	echo "manual" > /usr/share/controller/scripts/channel_mode
	echo $server > /usr/share/controller/api/server
	echo $user > /usr/share/controller/api/user
	echo $password > /usr/share/controller/api/password
	echo $port > /usr/share/controller/api/port
	cat ./AccessPoint-Scripts-main/cron/cron.conf | crontab -
	/etc/init.d/cron enable
	/etc/init.d/cron restart
	opkg remove unzip
	rm -rf ./AccessPoint-Scripts-main
	rm -rf ./AccessPoint-Scripts-main.zip
	uci commit wireless
	wifi
fi

