#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin;

caminho=/usr/share/controller

. /usr/share/libubox/jshn.sh

if [[ $1 == "sleep" ]]
then 
	sleep $(($RANDOM%15))
fi

$caminho/scripts/get_ca.sh
$caminho/scripts/get_blacklist.sh

controller_server=$(cat $caminho/api/server)
api_user=$(cat $caminho/api/user)
api_pass=$(cat $caminho/api/password)
api_port=$(cat $caminho/api/port)

ipv4=$(ifstatus wan |  jsonfilter -e '@["ipv4-address"][0].address')
ipv6=$(ifstatus wan |  jsonfilter -e '@["ipv6-address"][0].address')
mac=$(ifconfig | grep "eth0 " | awk '{print $5}')
ssid=$(uci get wireless.@wifi-iface[0].ssid)
channel=$(uci get wireless.radio0.channel)
channel_mode=$(cat $caminho/scripts/channel_mode)
password=$(uci get wireless.@wifi-iface[0].key)
pass_type=$(uci get wireless.@wifi-iface[0].encryption)
pass_server=$(uci get wireless.@wifi-iface[0].server)

json_init
json_add_string "mac" $mac
json_add_string "ipv4" $ipv4
json_add_string "ipv6" $ipv6
json_add_string "ssid" "$ssid"
json_add_string "channel_mode" $channel_mode
json_add_string "channel" $channel
json_add_string "password" $password

if [ -n $pass_type ]
then
	if [ $pass_type = "wpa2" ]
	then
		json_add_string "type_password" $pass_type
		json_add_string "wpa2_server" $pass_server
	else
		json_add_string "type_password" "default"
	fi
		
fi

json_add_array ca
while IFS= read -r LINE; do                                                               
    json_add_string "" ${LINE^^}
done < /tmp/ca.txt
json_close_array

json_add_array blacklist
while IFS= read -r LINE; do                               
    json_add_string "" ${LINE^^}                              
done < /tmp/blacklist.txt 
json_close_array

json_dump > $caminho/scripts/data.json                                                   
                                                                          
curl --max-time 5  -X PUT -u $api_user:$api_pass  http://$controller_server:$api_port/api/v2/ap -H "Content-Type: application/json" -d @$caminho/scripts/data.json > $caminho/scripts/result.json

$caminho/scripts/action.sh
